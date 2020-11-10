tool
extends Area2D

# energy signals for tracking the state of the obj
signal health_updated(health)
signal max_health_updated(max_health)
signal killed()
#energy signals
signal energy_updated(energy)
signal max_energy_updated(max_energy)
signal no_energy()

var missile: PackedScene = preload("res://assets/scenes/missiles/Missile.tscn")

export(String, "human", "alien") var kind = "human" setget set_kind
export var is_ai_controlled: bool = false
export(NodePath) var ui_items_box_node

const MOVE_SPEED = 390
export(float, EXP, 0.0, 1.0) var acceleration

# health
export (float) var max_health = 300
onready var health = max_health setget _set_health
# Energy 
export (float) var max_energy = 100
onready var energy = max_energy setget _set_energy


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
	set_process_input(true)
	set_physics_process(true)
	
#	call_deferred("shoot_missile")
	#changing the max health in the healthbar
	emit_signal("max_health_updated", max_health)
	emit_signal("max_energy_updated", max_energy)
	
	# Initialize selectable missiles
	if not is_ai_controlled:
		call_deferred("_on_ItemsBox_ready")
		get_node(ui_items_box_node).connect("item_used", self, "_on_ItemsBox_item_used")

func _on_ItemsBox_ready() -> void:
	var sbox = get_node(ui_items_box_node)
	# Disable every other missile option
	for item_slot in sbox.get_children():
		item_slot.set_disabled(true)
	# Insert the missile at option 1 for our kind of player
	sbox.new_slot(0, 0 if kind == "human" else 1) # ... Just see ItemsBox.new_slot

var used_first_missile = false
func _on_ItemsBox_item_used(idx, item_data) -> void:
	var sbox = get_node(ui_items_box_node)
	if idx == 0 and not used_first_missile:
		for item_slot in sbox.get_children():
			item_slot.set_disabled(false) # Re-enable all missile options

func _input(event: InputEvent) -> void:
	if is_ai_controlled: return
	if event is InputEventKey and event.pressed and not event.echo:
		var sbox = get_node(ui_items_box_node)
		if event.scancode >= 48 and event.scancode <= 57: # Within KEY_0 to KEY_9
			var missile_scn_path = sbox.use(event.scancode - 48 - 1)
			if missile_scn_path != null: # User entered an invalid option otherwise ...
				shoot_missile(missile_scn_path)

func _process(delta):
	if not is_ai_controlled:
		if Input.is_action_just_pressed("shield") and not energy == 0:
			$Shield.set_shield_enabled(true)
		if Input.is_action_just_released("shield"):
			$Shield.set_shield_enabled(false)




func _physics_process(delta):
	var m = Vector2()
	
	if not is_ai_controlled: # When this player is not controlled by an AI...
		if Input.is_action_pressed("up") and can_move_up:
			m.y -= 1
		if Input.is_action_pressed("down") and can_move_down:
			m.y += 1
	
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


func shoot_missile(missile_scn_path: String):
	var m = missile.instance()
	m.set_inner_scene(load(missile_scn_path))
	m.set_owner(self)
	m.target_node = get_opponent_node()
	get_tree().root.add_child(m)
	m.global_position = global_position
	m.look_at($MissileSpawn.global_position)
#	m.look_at(m.to_global(Vector2.LEFT if facing_opposite else Vector2.RIGHT))


func _on_area_entered(area):
	
	if area.is_in_group("boundary"):
		on_boundary(area, true)
	elif area.is_in_group("missile") and (area.get_owner() != self or area.get_target() == self):
		apply_damage(int(area.explode() * 100.0))
	elif area.is_in_group("astroids"):
		apply_damage(int(area.astroid_damage))


func _on_Player_area_exited(area):
	if area.is_in_group("boundary"): # If we left a boundary...
		on_boundary(area, false)

func appl_energy_damage(amount):
	_set_energy(energy - amount)

func apply_damage(amount):
	_set_health(health - amount)

# TODO things to do before the player dies like animations scoring points and so ....
func die():
	$SFX/Destroyed.play()
	yield($SFX/Destroyed, "finished")
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

func _set_energy(value):
	var prev_energy = energy
	energy = clamp(value, 0, max_energy)
	if not energy == prev_energy:
		emit_signal("energy_updated", energy)
		if energy == 0:
			emit_signal("no_energy")

func _on_slow_charging_speed(player):
	if player.to_lower() == kind.to_lower():
		
		# we might send the slow value from the missile as well ~!
		$Shield.energy_charge_speed -= 2
		appl_energy_damage(50)
		apply_damage(50)
	

# this called by get_tree() call group from astroid
func _on_astroid_hit_station(player, astroid_damage):
	if player.to_lower() == kind.to_lower():
		apply_damage(astroid_damage)
		appl_energy_damage(astroid_damage / 3)


