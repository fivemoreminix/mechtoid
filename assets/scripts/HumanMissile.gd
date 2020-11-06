extends Area2D

var speed = 500

# direction is local to the missile and normalized.
var direction = Vector2() setget set_direction

# Assumes `dir` is already normalized.
func set_direction(dir: Vector2) -> void:
	direction = dir
	look_at(dir)


func _ready():
	set_physics_process(true)


func _physics_process(delta):
	position += direction * speed * delta
