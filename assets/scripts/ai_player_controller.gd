extends Node

enum Difficulty { medium, hard }
export(Difficulty) var difficulty = Difficulty.medium
export var items_box_path: NodePath

onready var dad = get_parent()
onready var dad_side = dad.get_side()
onready var shield = dad.get_node("Shield")

# CAUTION: due to not thinking ahead, the Interface node has all UI server-wide,
# so that will need to be fixed before an AI or other player can have actual missile
# selection. Until then, the AI will only use its missile kind and simulate the timer.
onready var missile_option_data = Globals.OPTIONS[dad.get_kind_missile_option_index()]

### Behavior Options ###

var max_dist_sqr_to_use_shield = 10000 if difficulty == Difficulty.hard else 60000
var max_reaction_delay = 0.4 if difficulty == Difficulty.hard else 0.9
# The chance this AI will fire a missile any given frame when one is available
var chance_to_fire_missile = 0.01 if difficulty == Difficulty.hard else 0.001 # 0.0 to 1.0

### End Behavior Options ###

var previous_target = null # Node2D or null
var can_move: bool = false
var missile_still_alive: bool = false # Whether a missile we fired is still alive


func _ready() -> void:
	print(dad.get_kind_missile_option_index())
	assert(dad != null)
	set_process(true)
	
	shield.connect("deflected_missile", self, "_on_Shield_deflected_missile")


func _process(delta: float) -> void:
	# Missile firing:
	if can_fire_missile():
		var do_fire = randf() <= chance_to_fire_missile # Fire?
		if do_fire: fire_missile()
	
	var incoming_missiles = get_incoming_missiles()
	var incoming_asteroids = get_incoming_asteroids()
	if incoming_missiles.size() > 0 or incoming_asteroids.size() > 0:
		# Step 1: Find the closest missile that is coming at us:
		var closest_missile = get_closest_node2d_in_array(incoming_missiles)
		var closest_asteroid = get_closest_node2d_in_array(incoming_asteroids)
		
		# Step 2: Determine our target:
		# Always prefer missiles over asteroids
		var target = closest_missile if closest_missile != null else closest_asteroid
		
		# Step 3: Move there
		if target != previous_target: # If we're moving somewhere new,
			previous_target = target
			can_move = false # We cannot move UNTIL $MoveDelay timeout
			$MoveDelay.start(rand_range(0.1, max_reaction_delay))
		
		if can_move:
			move_to_global_y_pos(target.global_position.y)
		
		# Step 4: Use (or prepare) shield
		use_the_shield_when_ready(target)
	else: # When we have nothing to do ...
		previous_target = null # We have no target
		if shield.get_shield_enabled(): # Stop using the shield if we are
			shield.set_shield_enabled(false)


func fire_missile() -> void:
	if can_fire_missile(): # If we can fire a missile ...
		var missile = dad.shoot_missile(missile_option_data["scene"])
		missile_still_alive = true
		# We can spawn another missile after this signal is emitted:
		missile.connect("missile_exploded", self, "_on_missile_exploded")

func can_fire_missile() -> bool:
	return $SpawnMissileTimer.time_left <= 0.0 and not missile_still_alive


func use_the_shield_when_ready(on: Node2D) -> void:
	# When `on` is within a safe range to use the shield ...
	if dad.global_position.distance_squared_to(on.global_position) <= max_dist_sqr_to_use_shield:
		if not shield.get_shield_enabled(): # Enable the shield if not already enabled
			shield.set_shield_enabled(true)
	else:
		if shield.get_shield_enabled():
			shield.set_shield_enabled(false) # Stop using shield


func get_incoming_missiles() -> Array:
	var out = []
	for missile in get_tree().get_nodes_in_group("missile"):
		if missile.get_target() == dad:
			out.append(missile)
	return out


func get_incoming_asteroids() -> Array:
	var out = []
	for asteroid in get_tree().get_nodes_in_group("astroids"):
		var inbound = false # Whether the asteroid is coming to us
		if dad_side == "left": # If we're on the left side of the screen ...
			# Only consider an asteroid "incoming" when it is going our direction and not outide screen
			inbound = asteroid.direction < 0 and asteroid.global_position.x > 0.0
		else: # Or the right side ...
			inbound = asteroid.direction > 0 and asteroid.global_position.x <= dad.global_position.x
		# And within vertical screen area
		inbound = inbound and asteroid.global_position.y >= 0.0 and asteroid.global_position.y <= get_viewport().size.y
		
		if inbound:
			out.append(asteroid)
	
	return out


# Returns either Node2D or null if one could not be found.
func get_closest_node2d_in_array(arr: Array):
	if arr.size() <= 0: return null
	var closest_node = arr[0]
	var closest_dist = dad.global_position.distance_squared_to(closest_node.global_position)
	for i in range(1, arr.size()):
		var dist = dad.global_position.distance_squared_to(arr[i].global_position)
		if dist < closest_dist:
			closest_node = arr[i]
			closest_dist = dist
	return closest_node


func move_to_global_y_pos(y: int) -> void:
	var y_pos_difference = y - dad.global_position.y
	if y_pos_difference < 0: # If we need to go up ...
		dad.move(Vector2(0, -1), get_physics_process_delta_time()) # Tell the player to move up
	elif y_pos_difference > 0: # If we need to go down ...
		dad.move(Vector2(0, 1), get_physics_process_delta_time()) # Tell the player to move down


func _on_Shield_deflected_missile(missile) -> void:
	pass


func _on_MoveDelay_timeout() -> void:
	can_move = true # Allow movement when the $MoveDelay is finished


func _on_missile_exploded(missile: Missile) -> void:
	missile_still_alive = false
	$SpawnMissileTimer.start(missile_option_data["time"])
