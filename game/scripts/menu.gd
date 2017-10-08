extends Node

func _ready():
	""" Called every time the node is added to the scene.
	    Initialization here. """
	set_process(true)

func _process(delta):
	""" Check the interactions with the menu. """
	# Start game
	if (get_node("panel/start_game").is_pressed()):
		get_tree().change_scene("res://scenes/phases/phase_one.tscn")
	# Instructions
	if (get_node("panel/instructions").is_pressed()):
		get_tree().change_scene("res://scenes/instructions.tscn")
	# Credits
	if (get_node("panel/credits").is_pressed()):
		get_tree().change_scene("res://scenes/credits.tscn")
	# Quit game
	if (get_node("panel/quit_game").is_pressed()):
		get_tree().quit()
