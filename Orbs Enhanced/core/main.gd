extends Node2D

func _input(event):
	if event.is_action_pressed("up"):
		Util.journo_mode = false
		get_tree().change_scene_to_file("res://core/game/game.tscn")
		
	if event.is_action_pressed("down"):
		Util.journo_mode = false
		Util.interp_mode = true
		get_tree().change_scene_to_file("res://core/game/game.tscn")
	
	if event.is_action_pressed("journo"):
		Util.journo_mode = true
		get_tree().change_scene_to_file("res://core/game/game.tscn")
