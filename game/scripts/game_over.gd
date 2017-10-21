###
# This script is responsible for game over menu.
# Author: Breno Viana
# Version: 20/10/2017
###
extends Node2D

func _ready():
	""" Called every time the node is added to the scene.
		Initialization here. """
	set_process(true)

func _process(delta):
	""" Called every frame. Check the interactions with the menu. """
	# Start game
	if(get_node("panel/back").is_pressed()):
		get_tree().change_scene("res://scenes/main.tscn")
