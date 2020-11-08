extends %BASE%

# You are probably going to need a speed variable
# const speed = 200


# Called every _physics_update. Determines the movement of the missile.
move(target_node: Vector2, physics_delta: float) -> void:
	var m = get_parent()
	pass # TODO: Handle movement


# get_damage() returns a number between 0.0 and 1.0 determining how much
# damage the missile should do.
func get_damage() -> float:
	return 0.5


func can_deflect() -> bool:
	return true # TODO: Implement


# Let the missile know it got deflected
func deflected() -> void:
	pass # TODO: Handle being deflected
