###
# This script is responsible for main game menu.
# Author: Breno Viana
# Version: 20/10/2017
###
extends Node2D

func _ready():
	""" Called every time the node is added to the scene.
		Initialization here. """
	set_process(true)
	get_node("intro_song").play("intro")

func _process(delta):
	""" Called every frame. Check the interactions with the menu. """
	# Start game
	if(get_node("panel/start_game").is_pressed()):
		get_tree().change_scene("res://scenes/phases/phase_one.tscn")
	# Load Game
	if(get_node("panel/load_game").is_pressed()):
		get_tree().change_scene("res://scenes/menu/load_game.tscn")
	# Instructions
	if(get_node("panel/instructions").is_pressed()):
		get_tree().change_scene("res://scenes/menu/instructions.tscn")
	# Credits
	if(get_node("panel/credits").is_pressed()):
		get_tree().change_scene("res://scenes/menu/credits.tscn")
	# Quit game
	if(get_node("panel/quit_game").is_pressed()):
		get_tree().quit()
