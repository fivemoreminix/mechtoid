extends Node2D

onready var stars = $starLayer;
export (float) var scroll_speed = 0.5;
var x = 0;
var y = 0;
var w = 1280*2;
var h = 720;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	x += scroll_speed;
	x = 0 if x > w else x;
	stars.region_rect = Rect2(x, y, w, h);
