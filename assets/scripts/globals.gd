extends Node

# FOR: ItemSlot.gd and anything that needs it because gdscript is terrible at globals
# After adding or changing options here,
# please update the script in ItemsBox.
const OPTIONS = [
	{"tex": "res://assets/Missiles/missile.png", "scene": "res://assets/scenes/missiles/HumanMissile.tscn", "time": 5.0},
	{"tex": "res://assets/Missiles/alien_misssile.png", "scene": "res://assets/scenes/missiles/AlienMissile.tscn", "time": 5.0},
]

var difficulty := "medium"
var sounds: bool = true # Whether the game should play sounds
var music: bool = true # Whether the game should play music
var fullscreen: bool = false setget set_fullscreen
var borderless: bool = false setget set_borderless


func set_fullscreen(v: bool) -> void:
	fullscreen = v
	OS.window_fullscreen = v


func set_borderless(v: bool) -> void:
	borderless = v
	OS.window_borderless = v
