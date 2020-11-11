extends HBoxContainer

signal item_used(index, option_data)

var item_slot = preload("res://assets/scenes/ItemSlot.tscn")

# Slot items can be added in ItemSlot.gd
export(Array, int, "Human Missile", "Alien Missile") var items = []


func _ready() -> void:
	# Create every slot at the start of the game
	for i in range(items.size()):
		new_slot(i, items[i])


func new_slot(idx: int, slot_option: int) -> void:
	var slot = item_slot.instance()
	add_child(slot)
	slot.option = slot_option
	slot.get_node("Label").text = str(idx + 1)
	move_child(slot, idx) # Do a tree insert, moving every other slot in tree
	for i in range(idx+1, get_child_count()): # For every slot that was moved ...
		get_child(i).get_node("Label").text = str(i + 1) # Update their key


# Returns the a string of the missile scene path from the ItemSlot index. Will
# start the timer for the missile slot also. Returns null if the missile is not
# available to use yet OR it isn't an option.
func use(idx: int):
	var slot = get_child(idx)
	if slot == null: return null
	if slot.ready_to_use():
		slot.start_timer()
		emit_signal("item_used", idx, Globals.OPTIONS[slot.option])
		return slot.get_option_scene_path()
