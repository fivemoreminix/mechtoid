tool
extends Area2D

const MOVE_SPEED = 350
export(float, EXP, 0.0, 1.0) var acceleration

export var facing_opposite: bool = false setget set_facing
export var is_ai: bool = false # TODO: probably just make the AI controller a child node

# For use with boundaries (to keep ships from going off screen)
# In global direction, not local
var can_move_up: bool = true
var can_move_down: bool = true

var motion = Vector2()

# Change the direction this player is facing
func set_facing(opposite: bool) -> void:
	facing_opposite = opposite
	if $Sprite != null: $Sprite.flip_h = opposite


func _ready():
	if Engine.editor_hint:
		return # We don't want to do any processing in the editor (caused by tool mode)
	set_physics_process(true)


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
	position += motion * delta


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


func _on_area_entered(area):
	if area.is_in_group("boundary"):
		on_boundary(area, true)


func _on_Player_area_exited(area):
	if area.is_in_group("boundary"): # If we left a boundary...
		on_boundary(area, false)
