extends Area2D


func set_shield_enabled(val: bool) -> void:
	visible = val
	monitoring = val # Won't detect collisions if disabled


func _ready() -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	# TODO:
	# if missile: deflect it
	if area.is_in_group("missile"):
		pass
		if area.can_deflect():
			area.deflected()
			area.rotate(deg2rad(180))
			area.set_target(get_parent().get_opponent_node())
		else:
			set_shield_enabled(false)
	pass
