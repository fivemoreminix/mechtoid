extends Control

onready var energy_bar_under = $HealthBarUnder
onready var energy_bar = $HealthBar
onready var update_tween = $Tween
var default_max_value

func _ready():
	update_max_energybar(default_max_value)


func update_energy_bars(energy):
	energy_bar.value = energy
	update_tween.interpolate_property(energy_bar_under, "value", energy_bar_under.value, energy, 0.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.00)
	update_tween.start()

func update_max_energybar(max_energy):
	energy_bar.max_value = max_energy
	energy_bar_under.max_value = max_energy
	energy_bar.value = max_energy
	energy_bar_under.value = max_energy




func _on_LeftPlayer_energy_updated(energy):
	update_energy_bars(energy)


func _on_LeftPlayer_max_energy_updated(max_energy):
	default_max_value = max_energy


func _on_LeftPlayer2_energy_updated(energy):
	update_energy_bars(energy)


func _on_LeftPlayer2_max_energy_updated(max_energy):
	default_max_value = max_energy
