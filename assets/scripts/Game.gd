extends Node2D


func _ready():
	var ai = $LeftPlayer/AIPlayerController
	ai.difficulty = ai.Difficulty.medium if Globals.difficulty == "medium" else ai.Difficulty.hard


func _on_LeftPlayer_killed():
	get_tree().call_group("Checkwinner", "get_winner", "alien")


func _on_LeftPlayer2_killed():
	get_tree().call_group("Checkwinner", "get_winner", "human")
