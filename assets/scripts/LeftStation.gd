extends Area2D


export(String, "unassigned", "human", "alien") var side


func _on_LeftStation_area_entered(area):
	get_tree().call_group("screenshake","start", 0.5, 30, 15)

func _on_RightStation_area_entered(area):
	_on_LeftStation_area_entered(area)
