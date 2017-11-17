###
# This script is responsible for pause screen.
# Author: Breno Viana
# Version: 16/11/2017
###
extends Node2D

func _ready():
	""" Called every time the node is added to the scene.
		Initialization here. """
	# Set process
	set_process(true)
	set_process_input(true)

func _process(delta):
	# Check if the game is not paused
	if(not Globals.get("paused")):
		queue_free()