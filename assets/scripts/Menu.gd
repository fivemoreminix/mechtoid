extends Control

export var pause_game_on_visible: bool = true
export var allow_hiding_and_showing_with_escape: bool = true

onready var sfx_bus_idx := AudioServer.get_bus_index("SFX")
onready var music_bus_idx := AudioServer.get_bus_index("Music")


func _ready() -> void:
	set_process(true)
	$Panel/VBoxContainer/SingleplayerButton.grab_focus()
	
	# Initialize buttons
	$Panel/VBoxContainer/SoundsButton.pressed = Globals.sounds
	$Panel/VBoxContainer/MusicButton.pressed = Globals.music
	$Panel/VBoxContainer/FullscreenButton.pressed = Globals.fullscreen
	$Panel/VBoxContainer/BorderlessButton.pressed = Globals.borderless


func _process(delta: float) -> void:
	if allow_hiding_and_showing_with_escape and Input.is_action_just_pressed("pause"):
		visible = not visible


func start_game() -> void:
	get_tree().change_scene("res://assets/scenes/Game.tscn")
	hide() # Unpauses the game (hack)


func _on_Menu_visibility_changed() -> void:
	if pause_game_on_visible:
		get_tree().paused = visible


func _on_Copyright_meta_clicked(meta) -> void:
	OS.shell_open(meta) # Open the link in user's browser


func _on_SingleplayerButton_pressed() -> void:
	$Panel/DifficultyDialog.show()


func _on_SoundsButton_toggled(button_pressed: bool) -> void:
	Globals.sounds = button_pressed
	AudioServer.set_bus_volume_db(sfx_bus_idx, 0 if button_pressed else -60)


func _on_MusicButton_toggled(button_pressed: bool) -> void:
	Globals.music = button_pressed
	AudioServer.set_bus_volume_db(music_bus_idx, 0 if button_pressed else -60)


func _on_FullscreenButton_toggled(button_pressed: bool) -> void:
	Globals.fullscreen = button_pressed


func _on_BorderlessButton_toggled(button_pressed: bool) -> void:
	Globals.borderless = button_pressed


func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_MediumButton_pressed() -> void:
	Globals.difficulty = "medium"
	start_game()


func _on_HardButton_pressed() -> void:
	Globals.difficulty = "hard"
	start_game()
