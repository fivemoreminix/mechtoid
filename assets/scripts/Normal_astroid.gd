extends Area2D

export (Array, Texture) var astroids_textures
export var min_speed = Vector2(20, 10)
export var max_speed = Vector2(120, 50)
var speed = Vector2()
export var torque = 1.5 * PI
var direction = 1
export var deflection_power = -1.5
export var astroid_damage = 20

func _ready():
	init()
	randomize()

func spin(delta):
	rotate(torque * direction * delta)

func move(delta):
	position += speed * direction * delta

func _physics_process(delta):
	move(delta)
	spin(delta)

func init():
	var random_texture = randi() % astroids_textures.size() # pick a random texture
	$Sprite.set_texture(astroids_textures[random_texture]) 
	# get the size of the textture to set collision shape
	var radius = $Sprite.texture.get_size().x / 2 
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.radius = radius
	#pick a random direction
	direction *= pow(-1, randi() % 2)
	speed = Vector2(rand_range(min_speed.x, max_speed.x), rand_range(min_speed.y, max_speed.y))
	
	 

func deflect():
	direction *= deflection_power








func _on_Pop_out_timeout():
	$AnimationPlayer.play("Pop_out")
	$Destroyed.play()
	yield($Destroyed, "finished")
	queue_free()


func _on_Astroid_area_entered(area):
	if area.is_in_group("astroids"):
		deflect()
	if area.is_in_group("station"):
		get_tree().call_group("player", "_on_astroid_hit_station", area.side, astroid_damage)
		_on_Pop_out_timeout()
	if area.is_in_group("player"):
		deflect()
		_on_Pop_out_timeout()
