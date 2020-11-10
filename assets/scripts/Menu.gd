extends Control


func _ready() -> void:
	$Panel/VBoxContainer/SingleplayerButton.grab_focus()


func _on_Copyright_meta_clicked(meta) -> void:
	OS.shell_open(meta) # Open the link in user's browser


func _on_SingleplayerButton_pressed() -> void:
	# TODO: show a drop down for difficulty options
	get_tree().change_scene("res://assets/scenes/Game.tscn")


func _on_SoundsButton_toggled(button_pressed: bool) -> void:
	Globals.sounds = button_pressed


func _on_MusicButton_toggled(button_pressed: bool) -> void:
	Globals.music = button_pressed


func _on_FullscreenButton_toggled(button_pressed: bool) -> void:
	OS.window_fullscreen = button_pressed


func _on_BorderlessButton_toggled(button_pressed: bool) -> void:
	OS.window_borderless = button_pressed


func _on_QuitButton_pressed() -> void:
	get_tree().quit()
