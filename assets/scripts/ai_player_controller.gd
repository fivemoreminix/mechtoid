extends Node

enum Difficulty { easy, medium, hard }
export(Difficulty) var difficulty = Difficulty.medium

onready var dad = get_parent()
onready var shield = dad.get_node("Shield")


func _ready() -> void:
	assert(dad != null)
	set_process(true)
	
	shield.connect("deflected_missile", self, "_on_Shield_deflected_missile")


func _process(delta: float) -> void:
	pass
	# TODO:
	# get every missile in the scene,
	# if it is targeting us, then:
	#	align our y with it
	#	hold shield until it is deflected
	
	var incoming_missiles = get_incoming_missiles()
	if incoming_missiles.size() > 0:
		# Step 1: Find the closest missile that is coming at us:
		var closest_missile = incoming_missiles[0]
		var closest_dist = dad.global_position.distance_squared_to(closest_missile.global_position)
		for i in range(1, incoming_missiles.size()):
			var dist = dad.global_position.distance_squared_to(incoming_missiles[i].global_position)
			if dist < closest_dist:
				closest_missile = incoming_missiles[i]
				closest_dist = dist
		
		# Step 2: Align our position to be ready to receive said missile:
		var y_pos_difference = closest_missile.global_position.y - dad.global_position.y
		if y_pos_difference < 0: # If we need to go up ...
			dad.move(Vector2(0, -1), get_physics_process_delta_time()) # Tell the player to move up
		elif y_pos_difference > 0: # If we need to go down ...
			dad.move(Vector2(0, 1), get_physics_process_delta_time()) # Tell the player to move down
		
		# Step 3: Keep our shield going:
		if not shield.get_shield_enabled():
			
			shield.set_shield_enabled(true)
	else:
		if shield.get_shield_enabled():
			
			shield.set_shield_enabled(false)


func get_incoming_missiles() -> Array:
	var out = []
	for missile in get_tree().get_nodes_in_group("missile"):
		if missile.get_target() == dad:
			out.append(missile)
	return out


func _on_Shield_deflected_missile(missile) -> void:
	pass
