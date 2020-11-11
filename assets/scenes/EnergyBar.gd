extends Control

onready var energy_bar_under = $HealthBarUnder
onready var energy_bar = $HealthBar
onready var update_tween = $Tween
var default_max_value
var no_energy = false

export (Color) var danger_color_over = Color()
export (Color) var normal_color_over = Color()

export (Color) var danger_color_progress = Color()
export (Color) var normal_color_progress = Color()

export (Color) var recharging_color = Color()

export (float,0 , 1, 0.05) var danger_zone = 0.2


func assign_energy_color(energy):
	#wait till enegry is full again 
	if no_energy:
		energy_bar.tint_progress = recharging_color
		energy_bar.tint_over = danger_color_over
		if energy == default_max_value:
			no_energy = false
		else:
			return
		
	if energy < energy_bar.max_value * danger_zone:
		energy_bar.tint_progress = danger_color_progress
		energy_bar.tint_over = danger_color_over
	else:
		energy_bar.tint_progress = normal_color_progress
		energy_bar.tint_over = normal_color_over
	if energy == 0:
		no_energy = true


func _ready():
	update_max_energybar(default_max_value)


func update_energy_bars(energy):
	energy_bar.value = energy
	update_tween.interpolate_property(energy_bar_under, "value", energy_bar_under.value, energy, 0.0, Tween.TRANS_SINE)
	update_tween.start()
	assign_energy_color(energy)

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
