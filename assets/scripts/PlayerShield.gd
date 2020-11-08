extends Area2D


func set_shield_enabled(val: bool) -> void:
	visible = val
	set_deferred("monitoring", val) # Won't detect collisions if disabled
	if val:
		$ForceTimer.start()
	else:
		$ForceTimer.stop()


func _ready() -> void:
	set_process(true)
	set_shield_enabled(false)


func _process(delta: float) -> void:
	# TODO: update shader and shield appearance based on
	# how much time is left on ForceTimer
	pass


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("missile"):
		if area.can_deflect():
			area.deflected($ForceTimer.time_left / $ForceTimer.wait_time)
			area.rotate(deg2rad(180))
			area.set_target(get_parent().get_opponent_node())
		else:
			# TODO: run shield explosion / defeat animation
			set_shield_enabled(false)
