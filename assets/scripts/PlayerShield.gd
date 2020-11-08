extends Area2D


func set_shield_enabled(val: bool) -> void:
	visible = val
	set_deferred("monitoring", val) # Won't detect collisions if disabled


func _ready() -> void:
	set_shield_enabled(false)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("missile"):
		if area.can_deflect():
			area.deflected()
			area.rotate(deg2rad(180))
			area.set_target(get_parent().get_opponent_node())
		else:
			# TODO: run shield explosion / defeat animation
			set_shield_enabled(false)
