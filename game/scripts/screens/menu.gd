###
# This script is responsible for main game menu.
# Author: Breno Viana
# Version: 16/12/2017
###
extends Node2D

func _ready():
	""" Called every time the node is added to the scene.
		Initialization here. """
	get_node("intro_song").play("intro")
	set_process(true)

func _process(delta):
	""" Called every frame. Check the interactions with the menu. """
	# Start a new game
	if(get_node("panel/new_game").is_pressed()):
		get_tree().change_scene("res://scenes/levels/w1l1.tscn")
	# Load saved game
	if(get_node("panel/load_game").is_pressed()):
		get_tree().change_scene("res://scenes/screens/load_game.tscn")
	# Instructions
	if(get_node("panel/instructions").is_pressed()):
		get_tree().change_scene("res://scenes/screens/instructions.tscn")
	# Credits
	if(get_node("panel/credits").is_pressed()):
		get_tree().change_scene("res://scenes/screens/credits.tscn")
	# Quit game
	if(get_node("panel/quit_game").is_pressed()):
		get_tree().quit()
