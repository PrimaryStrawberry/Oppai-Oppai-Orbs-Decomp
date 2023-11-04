extends Node2D
class_name Game

enum FRUIT_TYPE{FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH, NINTH, TENTH, ELEVENTH, TWELFTH}

@onready var avatar = $Avatar
@onready var table = $Table
@onready var spawner = $Table/Spawner as Spawner
@onready var next_sprite = $CanvasLayer/Hud/Next
@onready var score_label = $CanvasLayer/Hud/Score
@onready var game_over_screen = $CanvasLayer/GameOver
@onready var connect_sfx = $ConnectSfx
@onready var progress_bar = $CanvasLayer/Hud/Bar
@onready var music_label = $CanvasLayer/Hud/MusicToggle
@onready var sound_label = $CanvasLayer/Hud/SoundToggle
@onready var coomer = $CanvasLayer/Hud/Coomer

@onready var fruit_first = preload("res://core/game/fruits/first.tscn")
@onready var fruit_second = preload("res://core/game/fruits/second.tscn")
@onready var fruit_third = preload("res://core/game/fruits/third.tscn")
@onready var fruit_fourth = preload("res://core/game/fruits/fourth.tscn")
@onready var fruit_fifth = preload("res://core/game/fruits/fifth.tscn")
@onready var fruit_sixth = preload("res://core/game/fruits/sixth.tscn")
@onready var fruit_seventh = preload("res://core/game/fruits/seventh.tscn")
@onready var fruit_eighth = preload("res://core/game/fruits/eighth.tscn")
@onready var fruit_ninth = preload("res://core/game/fruits/ninth.tscn")
@onready var fruit_tenth = preload("res://core/game/fruits/tenth.tscn")
@onready var fruit_eleventh = preload("res://core/game/fruits/eleventh.tscn")

@onready var sprite_first = preload("res://assets/graphics/slimes/01-36.png")
@onready var sprite_second = preload("res://assets/graphics/slimes/02-40.png")
@onready var sprite_third = preload("res://assets/graphics/slimes/03-48.png")
@onready var sprite_fourth = preload("res://assets/graphics/slimes/04-60.png")
@onready var sprite_fifth = preload("res://assets/graphics/slimes/05-76.png")

@onready var boom_part = preload("res://core/game/misc/boom_part.tscn")

var is_active:bool = false
var music_bus = AudioServer.get_bus_index("Music")
var sound_bus = AudioServer.get_bus_index("Sound")

var fruit_array:Array = []
var sprite_array:Array = []
var current_fruit:Fruit
var next_fruit:int = 0

var score:int = 0
var current_bust:FRUIT_TYPE
var bust_amount:int = 0
var bust_goal:int = 0
var bust_leveling:bool = false

signal ping_next_fruit
signal ping_drop_fruit
signal ping_update_score(value)
signal ping_update_bust(value)

func _ready():
	randomize()
	score = 0
	score_label.text = str(0)
	current_bust = FRUIT_TYPE.FIFTH
	progress_bar.value = 163
	
	AudioServer.set_bus_mute(music_bus, true)
	
	if AudioServer.is_bus_mute(music_bus):
		music_label.modulate.a = 0.4
	else:
		music_label.modulate.a = 1
	if AudioServer.is_bus_mute(sound_bus):
		sound_label.modulate.a = 0.4
	else:
		sound_label.modulate.a = 1
	
	if Util.journo_mode:
		coomer.show()
		bust_goal = 1
	else:
		coomer.hide()
		bust_goal = 2
	
	fruit_array = [fruit_first, fruit_second, fruit_third, fruit_fourth, fruit_fifth, fruit_sixth, fruit_seventh, fruit_eighth, fruit_ninth, fruit_tenth, fruit_eleventh]
	sprite_array = [sprite_first, sprite_second, sprite_third, sprite_fourth, sprite_fifth]
	connect("ping_drop_fruit", Callable(self, "drop_fruit"))
	connect("ping_update_score", Callable(self, "update_score"))
	connect("ping_update_bust", Callable(avatar, "update_bust"))
	
	is_active = true
	
	set_next_fruit()
	set_current_fruit()

func _physics_process(_delta):
	if current_fruit != null:
		if current_fruit.is_held:
			current_fruit.global_position.x = spawner.global_position.x

func set_current_fruit():
	if !is_active:
		return
	
	current_fruit = fruit_array[next_fruit].instantiate() as Fruit
	table.call_deferred("add_child", current_fruit)
	#current_fruit.call_deferred("spawn")
	current_fruit.connect("ping_first_contact", Callable(self, "ready_next"), CONNECT_ONE_SHOT)
	current_fruit.connect("ping_same_contact", Callable(self, "merge_fruit"))
	current_fruit.connect("ping_game_over", Callable(self, "game_over"))
	current_fruit.global_position = spawner.marker.global_position
	current_fruit.is_held = true
	current_fruit.first_contact = false
	
	set_next_fruit()

func set_next_fruit():
	next_fruit = randi_range(0, 3)
	next_sprite.texture = sprite_array[next_fruit]

func drop_fruit():
	if current_fruit == null:
		return
	
	current_fruit.gravity_scale = 1
	current_fruit.is_held = false

func ready_next():
	set_current_fruit()

func merge_fruit(a, b):
	var between = a.global_position.lerp(b.global_position, 0.5)
	var nu_type = a.fruit_type + 1
	emit_signal("ping_update_score", nu_type)
	
	if !a.first_contact:
		a.first_contact = true
		a.emit_signal("ping_first_contact")
	if !b.first_contact:
		b.first_contact = true
		b.emit_signal("ping_first_contact")
	
	a.destroy()
	b.destroy()
	connect_sfx.play()
	
	var parts = boom_part.instantiate() as Particles
	table.call_deferred("add_child", parts)
	parts.emitting = true
	parts.global_position = between
	
	if nu_type == current_bust:
		update_bust()
	
	if nu_type == FRUIT_TYPE.TWELFTH:
		return
	
	if bust_leveling:
		get_tree().paused = true
		await get_tree().create_timer(1.0).timeout
		get_tree().paused = false
		bust_leveling = false
	
	var nu = fruit_array[nu_type].instantiate() as Fruit
	table.call_deferred("add_child", nu)
	#nu.call_deferred("spawn")
	nu.first_contact = true
	nu.global_position = between
	nu.gravity_scale = 1
	nu.connect("ping_same_contact", Callable(self, "merge_fruit"))
	nu.connect("ping_game_over", Callable(self, "game_over"))

func update_score(value):
	score += int(value) + int(value - 1)
	score_label.text = str(score)

func update_bust():
	bust_amount += 1
	if bust_amount >= bust_goal:
		emit_signal("ping_update_bust", current_bust)
		progress_bar.value = avatar.bar_number
		current_bust += 1
		bust_amount = 0
		bust_leveling = true

func game_over():
	if is_active:
		is_active = false
		game_over_screen.show()

func _input(event):
	if event.is_action_pressed("down"):
		emit_signal("ping_drop_fruit")
	if event.is_action_pressed("up") && current_fruit == null:
		ready_next()
	if event.is_action_pressed("up") && !is_active:
		get_tree().reload_current_scene()
	
	if event.is_action_pressed("mute"):
		AudioServer.set_bus_mute(music_bus, !AudioServer.is_bus_mute(music_bus))
		if AudioServer.is_bus_mute(music_bus):
			music_label.modulate.a = 0.4
		else:
			music_label.modulate.a = 1
	if event.is_action_pressed("sound"):
		AudioServer.set_bus_mute(sound_bus, !AudioServer.is_bus_mute(sound_bus))
		if AudioServer.is_bus_mute(sound_bus):
			sound_label.modulate.a = 0.4
		else:
			sound_label.modulate.a = 1
	
	if event.is_action_pressed("reset"):
		#get_tree().reload_current_scene()
		get_tree().change_scene_to_file("res://core/main.tscn")
#	if event.is_action_pressed("quit"):
#		get_tree().quit()
