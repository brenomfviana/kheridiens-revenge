extends Node

func _ready():
	""" Called every time the node is added to the scene.
	    Initialization here. """
	# get_node("panel/ninja").play("anim")
	# get_node("panel/zombie1").play("anim")
	# get_node("panel/zombie2").play("anim")
	set_process(true)

func _process(delta):
	""" Check the interactions with the menu. """
	# Start game
	if (get_node("panel/start_game").is_pressed()):
		get_tree().change_scene("res://scenes/phases/phase_one.tscn")
	# Quit game
	if (get_node("panel/quit_game").is_pressed()):
		get_tree().quit()
