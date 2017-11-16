###
# This script is responsible for back button function.
# Author: Breno Viana
# Version: 16/11/2017
###
extends Node2D

func _ready():
	""" Called every time the node is added to the scene.
		Initialization here. """
	set_process(true)
	get_node("intro_song").play("intro")

func _process(delta):
	""" Called every frame. Check the interactions with the menu. """
	# Check if the back button was pressed
	if(get_node("panel/back").is_pressed()):
		get_tree().change_scene("res://scenes/screens/main.tscn")