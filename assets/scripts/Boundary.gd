extends Area2D

export(String, "unassigned", "up", "down") var side

func _ready():
	assert(side == "up" or side == "down")
