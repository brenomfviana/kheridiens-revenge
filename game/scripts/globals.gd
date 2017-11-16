###
# This script is responsible for game over menu.
# Author: Breno Viana
# Version: 16/11/2017
###
extends Node2D

func _ready():
	""" Called every time the node is added to the scene.
		Initialization here. """
	# Game settings
	Globals.set("paused", false)
	Globals.set("current_level", "w1l1")
	# Enemies settings
	Globals.set("enemy_group", "enemies")
	# Player attributes
	Globals.set("score", 0)
	Globals.set("number_of_lifes", 3)
	Globals.set("amount_of_kunais", 5)
