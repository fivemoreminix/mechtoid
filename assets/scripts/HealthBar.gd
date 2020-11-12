extends Control

onready var health_bar = $HealthBar
onready var health_bar_under = $HealthBarUnder
onready var update_tween = $Tween
var default_max_value

export (Color) var danger_color_over = Color()
export (Color) var normal_color_over = Color()

export (Color) var danger_color_progress = Color()
export (Color) var normal_color_progress = Color()

export (float,0 , 1, 0.05) var danger_zone = 0.2

func assign_health_color(health):
	if health < health_bar.max_value * danger_zone:
		health_bar.tint_progress = danger_color_progress
		health_bar.tint_over = danger_color_over
	else:
		health_bar.tint_progress = normal_color_progress
		health_bar.tint_over = normal_color_over


func _ready():
	update_max_healthbar(default_max_value)

func update_max_healthbar(max_health):
	health_bar.max_value = max_health
	health_bar_under.max_value = max_health
	health_bar.value = max_health
	health_bar_under.value = max_health

func update_health_bars(health):
	health_bar.value = health
	update_tween.interpolate_property(health_bar_under, "value", health_bar_under.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.4)
	update_tween.start()
	assign_health_color(health)

func _on_LeftPlayer_health_updated(health):
	update_health_bars(health)

func _on_LeftPlayer_max_health_updated(max_health):
	default_max_value = max_health


func _on_LeftPlayer2_health_updated(health):
	update_health_bars(health)


func _on_LeftPlayer2_max_health_updated(max_health):
	default_max_value = max_health



