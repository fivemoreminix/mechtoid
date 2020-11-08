extends CollisionShape2D

const TURN_SPEED = 3
const MAX_BOUNCES = 3

var speed = 300.0
var bounces = 0


func move(target_node, phys_delta):
	var m = get_parent()
	# TODO: maybe check if the target_node exists
	var target_rotation = m.get_angle_to(target_node.global_position)
	m.rotation += lerp(0, target_rotation, TURN_SPEED) * phys_delta
	
	# Always fly forward
	m.position += m.transform.basis_xform(Vector2.RIGHT) * speed * phys_delta
	# Apply sinoid wave
	var up = m.transform.basis_xform(Vector2.UP)
	m.position += up * sin(Engine.get_frames_drawn() / 5.0)


# explode() returns a number between 0.0 and 1.0 determining how much
# damage the missile should do. It also performs an animation before freeing
# the parent node.
# NOTE: Was previously known as "get_damage()"
func explode() -> float:
	# TODO: an animation
	# TODO: could probably do a great, negative gravity on this Area2D to simulate physical force
	# TODO: timer / end of animation we get_parent().queue_free()
	get_parent().queue_free() # ... for now ;)
	
	# + 1 because if it hasn't bounced it must still do damage
	return (bounces / float(MAX_BOUNCES) + 1)


func can_deflect() -> bool:
	return bounces < MAX_BOUNCES


# Let the missile know it got deflected, and with a force from 0.0 to 1.0.
func deflected(force: float) -> void:
	bounces += 1
	speed += 200.0 * force
	# TODO: flash red when deflected to maximum (self modulate)
