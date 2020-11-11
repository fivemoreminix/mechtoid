tool
extends Panel

# Named in the order of OPTIONS
export(int, "Human Missile", "Alien Missile") var option setget set_option
export var disabled = false setget set_disabled


func _process(delta: float) -> void:
	$TextureProgress.value = ($Timer.time_left / $Timer.wait_time) * 100


func set_disabled(val: bool) -> void:
	disabled = val
	if val:
		$TextureProgress.value = $TextureProgress.max_value # Full value makes it grey, so that's alright
		$Timer.stop() # When disabling the slot item, reset the timer
		set_process(false) # Also stop processing
	else:
		start_timer() # When enabling the slot item, start the timer (and start processing)


func set_option(opt: int) -> void:
	option = opt
	$TextureRect.texture = load(Globals.OPTIONS[opt]["tex"])


func get_option_scene_path() -> String:
	return Globals.OPTIONS[option]["scene"]


func ready_to_use() -> bool:
	return $Timer.is_stopped() and not disabled


func start_timer() -> void:
	$Timer.start(Globals.OPTIONS[option]["time"])
	set_process(true)


func _on_Timer_timeout() -> void:
	set_process(false)
	$AnimationPlayer.play("Ready")
