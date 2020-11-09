tool
extends HBoxContainer

var item_slot = preload("res://assets/scenes/ItemSlot.tscn")

# Slot options can be added in ItemSlot.gd
export(Array, int, "Human Missile") var options = [] setget set_options


func set_options(opts) -> void:
	options = opts
	for c in get_children():
		c.queue_free() # Remove all children
	
	for i in range(opts.size()):
		var slot = item_slot.instance()
		add_child(slot)
		slot.option = opts[i]
		slot.get_node("Label").text = str(i + 1)


# Returns the a string of the missile scene path from the ItemSlot index.
#
# Will return null if that slot cannot be found.
func get_option_missile_scene_path(idx: int):
	var slot = get_child(idx)
	if slot == null: return null
	return slot.get_option_scene_path()
