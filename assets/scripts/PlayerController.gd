tool
extends Area2D

const MOVE_SPEED = 350
export(float, EXP, 0.0, 1.0) var acceleration

export var facing_down: bool = false setget set_facing
export var is_ai: bool = false # TODO: probably just make the AI controller a child node

# For use with boundaries (to keep ships from going off screen)
# In global direction, not local
var can_move_left: bool = true
var can_move_right: bool = true

var motion = Vector2()


func set_facing(is_down: bool) -> void:
	facing_down = is_down
	if $Sprite != null: $Sprite.flip_v = is_down


func _ready():
	if Engine.editor_hint:
		return # We don't want to do any processing in the editor (caused by tool mode)
	set_physics_process(true)


func _physics_process(delta):
	var m = Vector2()
	
#	if Input.is_action_pressed("up"):
#		motion.y -= 1
#	if Input.is_action_pressed("down"):
#		motion.y += 1
	if Input.is_action_pressed("left") and can_move_left:
		m.x -= 1
	if Input.is_action_pressed("right") and can_move_right:
		m.x += 1
	
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
		if area.side == "left": # Disallow movement in the direction of the boundary
			can_move_left = false
		if area.side == "right":
			can_move_right = false
	else:
		if area.side == "left": # Re-enable movement in the direction of the boundary
			can_move_left = true
		if area.side == "right":
			can_move_right = true


func _on_area_entered(area):
	if area.is_in_group("boundary"):
		on_boundary(area, true)


func _on_Player_area_exited(area):
	if area.is_in_group("boundary"): # If we left a boundary...
		on_boundary(area, false)
