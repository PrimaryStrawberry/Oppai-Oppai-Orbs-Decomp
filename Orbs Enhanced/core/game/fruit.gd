extends RigidBody2D
class_name Fruit

##11 types of fruits
enum FRUIT_TYPE{FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH, NINTH, TENTH, ELEVENTH, TWELFTH}

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

@export var fruit_type:FRUIT_TYPE
var radius:int = 0

var is_held:bool = false
var first_contact:bool = true
var maximum_size:Vector2

signal ping_first_contact
signal ping_same_contact(a, b)
signal ping_game_over

func _ready():
	radius = $CollisionShape2D.shape.radius + 2
	spawn()

func spawn():
	#scale = Vector2(0.1, 0.1)
	if Util.journo_mode:
		maximum_size = Vector2(0.8, 0.8)
	else:
		maximum_size = Vector2(1, 1)
	var tween = create_tween().set_parallel()
	#tween.tween_property(self, "scale", maximum_size, 0.1)
	tween.tween_property(sprite, "scale", maximum_size, 0.1).from(Vector2(0.1, 0.1))
	tween.tween_property(collision, "scale", maximum_size, 0.1).from(Vector2(0.1, 0.1))

func destroy():
	queue_free()

func _on_body_entered(body):
	if !first_contact:
		if body.is_in_group("fruit") || body.is_in_group("floor"):
			first_contact = true
			emit_signal("ping_first_contact")
	
	if body.is_in_group("fruit"):
		if !first_contact:
			first_contact = true
			emit_signal("ping_first_contact")
		if fruit_type == body.fruit_type:
			body.contact_monitor = false
			emit_signal("ping_same_contact", self, body)

func _on_visible_on_screen_notifier_2d_screen_exited():
	print("OFFSCREEN")
	emit_signal("ping_game_over")
	await get_tree().create_timer(0.5).timeout
	queue_free()
