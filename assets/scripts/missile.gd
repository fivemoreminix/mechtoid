extends Area2D

# This is a pretty fancy script. It acts as an interface to all types of missiles
# via functions. The child "InnerMissile" must exist and have a script which
# implements all of the below functions:
#
# move(global_dir: Vector2, physics_delta: float) -> void
# get_damage() -> float # 0.0 to 1.0
# can_deflect() -> bool
# deflected() -> void # let the missile know it got deflected

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
var target_node: Node setget set_target, get_target


func set_owner(new: Node) -> void:
	owning_node = new

func get_owner() -> Node:
	return owning_node

func set_target(new: Node) -> void:
	target_node = new

func get_target() -> Node:
	return target_node


func _ready() -> void:
	assert(inner != null)
	set_physics_process(true)


func _physics_process(delta) -> void:
	inner.move(target_node, delta)


# Returns an amount of damage from 0.0 to 1.0
# NOTE: Was previously known as "get_damage()"
func explode() -> float:
	return inner.explode()


# Returns if the missile agrees to being deflected
func can_deflect() -> bool:
	return inner.can_deflect()


# Let the missile know it got deflected, and with a force from 0.0 to 1.0.
func deflected(force: float) -> void:
	inner.deflected(force)

# Animation needed for the explosion
func exploision():
	set_physics_process(false) # to stop the missile from moving 

	$Destroyed.play()
	yield($Destroyed, "finished")
	queue_free()


