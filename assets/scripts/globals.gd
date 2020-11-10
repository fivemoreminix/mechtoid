extends Node

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
