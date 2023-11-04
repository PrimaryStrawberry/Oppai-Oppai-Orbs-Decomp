extends Node2D
class_name Avatar

enum FRUIT_TYPE{FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH, NINTH, TENTH, ELEVENTH, TWELFTH}

@onready var girl_fourth = preload("res://assets/graphics/girl/girl-04.png")
@onready var girl_fifth = preload("res://assets/graphics/girl/girl-05.png")
@onready var girl_sixth = preload("res://assets/graphics/girl/girl-06.png")
@onready var girl_seventh = preload("res://assets/graphics/girl/girl-07.png")
@onready var girl_eighth = preload("res://assets/graphics/girl/girl-08.png")
@onready var girl_ninth = preload("res://assets/graphics/girl/girl-09.png")
@onready var girl_tenth = preload("res://assets/graphics/girl/girl-10.png")
@onready var girl_eleventh = preload("res://assets/graphics/girl/girl-11.png")
@onready var girl_twelfth = preload("res://assets/graphics/girl/girl-12.png")

@onready var boobs_none = preload("res://assets/graphics/girl/boobs-00.png")

@onready var boobs_seventh = preload("res://assets/graphics/girl/boobs-07.png")
@onready var boobs_eighth = preload("res://assets/graphics/girl/boobs-08.png")
@onready var boobs_ninth = preload("res://assets/graphics/girl/boobs-09.png")
@onready var boobs_tenth = preload("res://assets/graphics/girl/boobs-10.png")
@onready var boobs_eleventh = preload("res://assets/graphics/girl/boobs-11.png")
@onready var boobs_twelfth = preload("res://assets/graphics/girl/boobs-12.png")


@onready var sprite = $Girl
@onready var boobs_sprite = $GirlBreasts
var current_bust:FRUIT_TYPE
var bar_number:int = 0

@onready var bust_particles = $BustUpPart
@onready var bust_sfx = $BustSfx

func _ready():
	current_bust = FRUIT_TYPE.NINTH
	bar_number = 163

func update_bust(bust):
	bust_sfx.play()
	match bust:
		FRUIT_TYPE.FOURTH:
			print_debug("FOURTH")
			sprite.texture = girl_fourth
			boobs_sprite.texture = boobs_none
			bar_number = 163
		FRUIT_TYPE.FIFTH:
			print_debug("FIFTH")
			sprite.texture = girl_fifth
			boobs_sprite.texture = boobs_none
			bar_number = 203
		FRUIT_TYPE.SIXTH:
			print_debug("SIXTH")
			sprite.texture = girl_sixth
			boobs_sprite.texture = boobs_none
			bar_number = 243
		FRUIT_TYPE.SEVENTH:
			print_debug("SEVENTH")
			sprite.texture = girl_seventh
			boobs_sprite.texture = boobs_seventh
			bar_number = 283
		FRUIT_TYPE.EIGHTH:
			print_debug("EIGHTH")
			sprite.texture = girl_eighth
			boobs_sprite.texture = boobs_eighth
			bar_number = 323
		FRUIT_TYPE.NINTH:
			print_debug("NINTH")
			sprite.texture = girl_ninth
			boobs_sprite.texture = boobs_ninth
			bar_number = 363
		FRUIT_TYPE.TENTH:
			print_debug("TENTH")
			sprite.texture = girl_tenth
			boobs_sprite.texture = boobs_tenth
			bar_number = 403
		FRUIT_TYPE.ELEVENTH:
			print_debug("ELEVENTH")
			sprite.texture = girl_eleventh
			boobs_sprite.texture = boobs_eleventh
			bar_number = 443
		FRUIT_TYPE.TWELFTH:
			print_debug("TWELFTH")
			sprite.texture = girl_twelfth
			boobs_sprite.texture = boobs_twelfth
			bar_number = 485
	
	bust_particles.emitting = true
