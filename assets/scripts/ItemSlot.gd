tool
extends Panel

# After adding or changing options here,
# please update the script in ItemsBox.
const OPTIONS = [
	{"tex": "res://assets/Missiles/missile.png", "scene": "res://assets/scenes/missiles/HumanMissile.tscn", "time": 5.0}
]

# Named in the order of OPTIONS
export(int, "Human Missile") var option setget set_option


func _process(delta: float) -> void:
	$TextureProgress.value = ($Timer.time_left / $Timer.wait_time) * 100


func set_option(opt: int) -> void:
	option = opt
	$TextureRect.texture = load(OPTIONS[opt]["tex"])


func get_option_scene_path() -> String:
	return OPTIONS[option]["scene"]


func ready_to_use() -> bool:
	return $Timer.is_stopped()


func start_timer() -> void:
	$Timer.start(OPTIONS[option]["time"])
	set_process(true)


func _on_Timer_timeout() -> void:
	set_process(false)
	$AnimationPlayer.play("Ready")
