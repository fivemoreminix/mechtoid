extends Node

enum Difficulty { medium, hard }
export(Difficulty) var difficulty = Difficulty.medium
export var items_box_path: NodePath

onready var dad = get_parent()
onready var shield = dad.get_node("Shield")
# An Array of Dictionaries
onready var internal_items_box: Array = get_items_box_items()
onready var max_dist_sqr_to_use_shield = 10000 if difficulty == Difficulty.hard else 60000
onready var max_reaction_delay = 0.4 if difficulty == Difficulty.hard else 0.9

var previous_target = null # Node2D or null
var can_move: bool = false


func get_items_box_items() -> Array:
	var arr = []
	for item in get_node(items_box_path).get_children():
		arr += [Globals.OPTIONS[item.option]] # arr becomes an array of dictionaries
	return arr


func _ready() -> void:
	assert(dad != null)
	set_process(true)
	
	shield.connect("deflected_missile", self, "_on_Shield_deflected_missile")
	# Insert our character kind's missile into internal_items_box
	internal_items_box.insert(0, Globals.OPTIONS[dad.get_kind_missile_option_index()])


func _process(delta: float) -> void:
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
	# TODO: ignore asteroids out of reach or behind us
	var out = []
	for asteroid in get_tree().get_nodes_in_group("astroids"):
		if asteroid.direction < 0:
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
