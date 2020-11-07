extends %BASE%

# You are probably going to need a speed variable
# const speed = 200


# Called every _physics_update. Determines the movement of the missile.
move(global_dir: Vector2, physics_delta: float) -> void:
	global_position += global_dir * speed * phys_delta # Fly straight


# get_damage() returns a number between 0.0 and 1.0 determining how much
# damage the missile should do.
get_damage() -> float:
	return 0.5
