extends Node2D

onready var positions = $Positions

export var max_astroids_to_send = 6
export var min_astroids_to_send = 2

var scene = preload("res://assets/scenes/Astroid.tscn")

func _ready():
	randomize()

func set_astroids_to_send():
	return rand_range(min_astroids_to_send, max_astroids_to_send)

func pick_random_position():
	return rand_range(0, positions.get_child_count())

func _on_SendAstroid_timeout():
	for x in set_astroids_to_send():
		var astroid = scene.instance()
		astroid.position = positions.get_child(pick_random_position()).position
		get_parent().add_child(astroid)
