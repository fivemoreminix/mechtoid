tool
extends Panel

# After adding or changing options here,
# please update the script in ItemsBox.
const OPTIONS = [
	{"tex": "res://assets/Missiles/missile.png", "scene": "res://assets/scenes/missiles/HumanMissile.tscn"}
]

# Named in the order of OPTIONS
export(int, "Human Missile") var option setget set_option


func set_option(opt: int) -> void:
	option = opt
	$TextureRect.texture = load(OPTIONS[opt]["tex"])


func get_option_scene_path() -> String:
	return OPTIONS[option]["scene"]
