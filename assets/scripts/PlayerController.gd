tool
extends Area2D

const MOVE_SPEED = 500

export var facing_down: bool = false setget set_facing
export var is_ai: bool = false # TODO: probably just make the AI controller a child node

# For use with boundaries (to keep ships from going off screen)
# In global direction, not local
var can_move_left: bool = true
var can_move_right: bool = true


func set_facing(is_down: bool) -> void:
	facing_down = is_down
	if $Sprite != null: $Sprite.flip_v = is_down


func _ready():
	if Engine.editor_hint:
		return # We don't want to do any processing in the editor (caused by tool mode)
	set_physics_process(true)


func _physics_process(_delta):
	var motion = Vector2()
	
#	if Input.is_action_pressed("up"):
#		motion.y -= 1
#	if Input.is_action_pressed("down"):
#		motion.y += 1
	if Input.is_action_pressed("left") and can_move_left:
		motion.x -= 1
	if Input.is_action_pressed("right") and can_move_right:
		motion.x += 1
	
	move(motion)


# Move the player in the given direction. Assumes `motion` is global and not normalized.
func move(motion: Vector2) -> void:
	position += motion.normalized() * get_physics_process_delta_time() * MOVE_SPEED


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
