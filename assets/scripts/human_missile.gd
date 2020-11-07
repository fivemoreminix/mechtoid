extends CollisionShape2D

const TWO_PI = 2.0 * PI

const speed = 300
const turn_speed = 2
const max_bounces = 3

var bounces = 0


func move(target_node, phys_delta):
	var m = get_parent()
	# TODO: maybe check if the target_node exists
	var target_rotation = m.get_angle_to(target_node.global_position)
	m.rotation += lerp(0, target_rotation, turn_speed) * phys_delta
	
	# Always fly forward
	m.position += m.transform.basis_xform(Vector2.RIGHT) * speed * phys_delta
	# Apply sinoid wave
	var up = m.transform.basis_xform(Vector2.UP)
	m.position += up * sin(Engine.get_frames_drawn() / 5.0)
