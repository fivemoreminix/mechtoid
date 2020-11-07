extends CollisionShape2D

const speed = 200


func move(global_dir, phys_delta):
	global_position += global_dir * speed * phys_delta
	var s = sin(global_position.x * 0.01)
	global_position.y += s+0.5
