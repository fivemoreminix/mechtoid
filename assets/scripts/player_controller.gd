tool
extends Area2D

# health signals for tracking the state of the obj
signal health_updated(health)
signal max_health_updated(max_health)
signal killed()

var missile: PackedScene = preload("res://assets/scenes/missiles/Missile.tscn")

export(String, "human", "alien") var kind = "human" setget set_kind

const MOVE_SPEED = 350
export(float, EXP, 0.0, 1.0) var acceleration

# Health
export (float) var max_health = 300
onready var health = max_health setget _set_health

# For use with boundaries (to keep ships from going off screen)
# In global direction, not local
var can_move_up: bool = true
var can_move_down: bool = true

var motion = Vector2()


func set_kind(v: String) -> void:
	kind = v
	match v:
		"human": $Sprite.texture = load("res://assets/Robots/robot.png")
		"alien": $Sprite.texture = load("res://assets/Robots/AlienRobot.png")


func _ready():
	if Engine.editor_hint:
		return # We don't want to do any processing in the editor (caused by tool mode)
	set_process(true)
	set_physics_process(true)
	
	call_deferred("shoot_missile")
	#changing the max health in the healthbar
	emit_signal("max_health_updated", max_health)

func _process(_delta):
	if Input.is_action_just_pressed("shield"):
		$Shield.set_shield_enabled(true)
	if Input.is_action_just_released("shield"):
		$Shield.set_shield_enabled(false)
#	if Input.is_action_just_pressed("fire_missile"):
#		shoot_missile()


func _physics_process(delta):
	var m = Vector2()
	
	if Input.is_action_pressed("up") and can_move_up:
		m.y -= 1
	if Input.is_action_pressed("down") and can_move_down:
		m.y += 1
#	if Input.is_action_pressed("left"):
#		m.x -= 1
#	if Input.is_action_pressed("right"):
#		m.x += 1
	
	move(m.normalized(), delta)


# Move the player in the given direction. Assumes `m` is global and normalized.
# `delta` must be the _physics_process delta time.
func move(m: Vector2, delta: float) -> void:
	# Ease actual move speed toward motion out of max move speed
	var target_speed = m * Vector2(MOVE_SPEED, MOVE_SPEED)
	motion = Vector2(
		lerp(motion.x, target_speed.x, acceleration),
		lerp(motion.y, target_speed.y, acceleration)
	)
	global_position += motion * delta


# on_boundary handles when a ship hits a boundary on either the left or right side.
func on_boundary(area: Node, entering: bool) -> void:
	# See Boundary.gd
	if entering:
		if area.side == "up": # Disallow movement in the direction of the boundary
			can_move_up = false
		if area.side == "down":
			can_move_down = false
	else:
		if area.side == "up": # Re-enable movement in the direction of the boundary
			can_move_up = true
		if area.side == "down":
			can_move_down = true


func get_opponent_node():
	for player in get_tree().get_nodes_in_group("player"):
		if player != self: return player
	assert(false)


func shoot_missile():
	var m = missile.instance()
	m.set_inner_scene(preload("res://assets/scenes/missiles/HumanMissile.tscn"))
	m.set_owner(self)
	get_tree().root.add_child(m)
	m.target_node = get_opponent_node()
	m.global_position = global_position
	m.look_at($MissileSpawn.global_position)
#	m.look_at(m.to_global(Vector2.LEFT if facing_opposite else Vector2.RIGHT))


func _on_area_entered(area):
	if area.is_in_group("boundary"):
		on_boundary(area, true)
	elif area.is_in_group("missile") and (area.get_owner() != self or area.get_target() == self):
		apply_damage(int(area.get_damage() * 100.0))


func _on_Player_area_exited(area):
	if area.is_in_group("boundary"): # If we left a boundary...
		on_boundary(area, false)


func apply_damage(amount):
	_set_health(health - amount)

# TODO things to do before the player dies like animations scoring points and so ....
func die():
	print_debug("DEAD")
	#queue_free()


func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	
	if not health == prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			die() 
			emit_signal("killed")








