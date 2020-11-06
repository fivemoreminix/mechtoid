extends Area2D

export(String, "unassigned", "left", "right") var side

func _ready():
	assert(side == "left" or side == "right")
