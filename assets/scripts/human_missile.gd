extends CollisionShape2D

const TWO_PI = 2.0 * PI

const speed = 200
const turn_speed = 2
const max_bounces = 3

var bounces = 0


func move(target_node, phys_delta):
	var m = get_parent()
#	global_position += global_dir * speed * phys_delta
#	var s = sin(global_position.x * 0.01)
#	global_position.y += s+0.5
	# TODO: maybe check if the target_node exists
	var target_rotation = m.get_angle_to(target_node.global_position)
	m.rotation += lerp(0, target_rotation, turn_speed) * phys_delta
#	m.look_at(target_node.global_position)
	
	# Always fly forward
	m.position += m.transform.basis_xform(Vector2.RIGHT) * speed * phys_delta


#func angle_between(a: Vector2, b: Vector2):
#	var theta = atan2(b.x - a.x, a.y - b.y)
#	if (theta < 0.0):
#		theta += TWO_PI
#	return rad2deg(theta)
