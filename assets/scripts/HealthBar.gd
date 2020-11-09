extends Control

onready var health_bar = $HealthBar
onready var health_bar_under = $HealthBarUnder
onready var update_tween = $Tween
var default_max_health

func _ready():
	update_max_healthbar(default_max_health)

func update_max_healthbar(max_health):
	health_bar.max_value = max_health
	health_bar_under.max_value = max_health
	health_bar.value = max_health
	health_bar_under.value = max_health

func update_health_bars(health):
	health_bar.value = health
	update_tween.interpolate_property(health_bar_under, "value", health_bar_under.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.4)
	update_tween.start()

func _on_LeftPlayer_health_updated(health):
	update_health_bars(health)

func _on_LeftPlayer_max_health_updated(max_health):
	default_max_health = max_health


func _on_LeftPlayer2_health_updated(health):
	update_health_bars(health)


func _on_LeftPlayer2_max_health_updated(max_health):
	default_max_health = max_health

