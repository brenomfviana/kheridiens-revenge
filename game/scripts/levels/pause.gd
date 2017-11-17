###
# This script is responsible for show pause screen.
# Author: Breno Viana
# Version: 16/11/2017
###
extends Node2D

func _ready():
	""" Called every time the node is added to the scene.
		Initialization here. """
	# Set processes
	set_process(true);

func _process(delta):
	# Check if the game is paused
	if(Globals.get("paused")):
		add_child(load("res://scenes/screens/pause_screen.tscn").instance())