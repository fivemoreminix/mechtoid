extends HBoxContainer

var item_slot = preload("res://assets/scenes/ItemSlot.tscn")

# Slot options can be added in ItemSlot.gd
export(Array, int, "Human Missile") var options = []


func _ready() -> void:
	# Create every slot at the start of the game
	for i in range(options.size()):
		var slot = item_slot.instance()
		add_child(slot)
		slot.option = options[i]
		slot.get_node("Label").text = str(i + 1)


# Returns the a string of the missile scene path from the ItemSlot index. Will
# start the timer for the missile slot also. Returns null if the missile is not
# available to use yet OR it isn't an option.
func use(idx: int):
	var slot = get_child(idx)
	if slot == null: return null
	if slot.ready_to_use():
		slot.start_timer()
		return slot.get_option_scene_path()
