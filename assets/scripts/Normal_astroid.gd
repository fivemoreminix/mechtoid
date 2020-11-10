extends RigidBody2D

export (Array, Texture) var astroids_textures


func _ready():
	init()
	randomize()


func init():
	var radius = $Sprite.texture.get_size().x / 2
	
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.radius = radius
#
#	position = _position
#	radius = _radius
#	$CollisionPolygon2D.shape = $CollisionPolygon2D.shape.duplicate()
#	$CollisionPolygon2D.shape.radius = radius
#	var img_size = $Sprite.texture.get_size().x / 2
#	$Sprite.scale = Vector2(1, 1) * radius / img_size
#	orbit_position.position.x = orbit_margin
#	rotation_speed *= pow(-1, randi() % 2)


