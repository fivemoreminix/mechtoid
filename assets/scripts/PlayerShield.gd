extends Area2D

signal deflected_missile(missile)
var is_charging = false
var is_drainging = false
var wait_full_charging = false

export var energy_charge_speed = 20 
export var energy_draining_speed = 50

func set_shield_enabled(val: bool) -> void:
	if not wait_full_charging:
		visible = val
		set_deferred("monitoring", val) # Won't detect collisions if disabled
		if val:
			is_drainging = true
			$SFX/ShieldActivated.play()
			$ForceTimer.start()
		else:
			is_drainging = false
			is_charging = true
			$SFX/ShieldDeactivated.play()
			$ForceTimer.stop()

func get_shield_enabled() -> bool:
	return visible


func _ready() -> void:
	set_process(true)
	set_shield_enabled(false)


func _process(delta: float) -> void:
	charging(delta)
	draining(delta)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("missile"):
		if area.can_deflect():
			area.deflected($ForceTimer.time_left / $ForceTimer.wait_time)
			area.rotate(deg2rad(180))
			area.set_target(get_parent().get_opponent_node())
			$SFX/ShieldHit.play()
			emit_signal("deflected_missile", area)
		else:
			# TODO: run shield explosion / defeat animation
			set_shield_enabled(false)
	if area.is_in_group("astroids"):
		area.deflect()
		$SFX/ShieldHitAstroid.play()


func charging(delta):
	if is_charging:
		get_parent()._set_energy(get_parent().energy + energy_charge_speed * delta)
		if get_parent().energy == get_parent().max_energy:
			wait_full_charging = false

func draining(delta):
	if is_drainging:
		is_charging = false
		get_parent()._set_energy(get_parent().energy - energy_draining_speed * delta)

func _on_Player_no_energy():
	set_shield_enabled(false)
	wait_full_charging = true
