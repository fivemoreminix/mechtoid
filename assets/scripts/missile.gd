tool
extends Area2D

# This is a pretty fancy script. It acts as an interface to all types of missiles
# via functions. The child "InnerMissile" must exist and have a script which
# implements all of the below functions:
#
# move(global_dir: Vector2, physics_delta: float) -> void
# get_damage() -> float # 0.0 to 1.0

export var inner_missile_scene: PackedScene setget set_inner_scene
onready var inner: Node

func set_inner_scene(scn: PackedScene) -> void:
	inner_missile_scene = scn
	if has_node("InnerMissile"):
		$InnerMissile.queue_free()
	var m = inner_missile_scene.instance()
	add_child(m)
	m.name = "InnerMissile"
	
	inner = m

# The player who this missile belongs to.
# Not necessarily the parent of this node.
var owning_node: Node setget set_owner, get_owner
# direction is global and normalized.
var global_direction = Vector2() setget set_direction

func set_owner(new: Node) -> void:
	owning_node = new

func get_owner() -> Node:
	return owning_node

# Assumes `global_dir` is already normalized.
func set_direction(global_dir: Vector2) -> void:
	global_direction = global_dir
	if not Engine.editor_hint:
		look_at(to_global(global_dir)) # Little bit of a hack...


func _ready() -> void:
	assert(inner != null)
	set_physics_process(true)


func _physics_process(delta) -> void:
	if Engine.editor_hint: return
	inner.move(global_direction, delta)


# Returns an amount of damage from 0.0 to 1.0
func get_damage() -> float:
	return inner.get_damage()
