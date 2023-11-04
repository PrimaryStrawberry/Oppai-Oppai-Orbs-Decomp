extends Sprite2D
class_name Spawner

@onready var marker = $Marker2D

@export var limits = Vector2(160, 560)
var radius = 5
var speed = 300

func _process(delta):
	if Input.is_action_pressed("left"):
		position.x -= speed * delta
	if Input.is_action_pressed("right"):
		position.x += speed * delta
	
	position.x = clamp(position.x, limits.x + radius, limits.y - radius)
