extends Control


func _ready() -> void:
	$Panel/VBoxContainer/SingleplayerButton.grab_focus()


func _on_Copyright_meta_clicked(meta) -> void:
	OS.shell_open(meta) # Open the link in user's browser
