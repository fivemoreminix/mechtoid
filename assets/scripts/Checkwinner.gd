extends Control

var main_menu = "res://assets/scenes/MainMenu.tscn"
var new_game = "res://assets/scenes/Game.tscn"
onready var show_winner = $Panel/Panel/ShowWinner


func get_winner(player):
	if player == "alien":
		show_winner.text = "You Won !"
		$AnimationPlayer.play("In")
	else:
		show_winner.text = "You Lose !"
		$AnimationPlayer.play("In")

func _ready():
	hide()


func _on_Restart_pressed():
	get_tree().change_scene(new_game)

func _on_Back_pressed():
	get_tree().change_scene(main_menu)


func _on_Quit_pressed():
	get_tree().quit()
