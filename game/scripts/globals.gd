###
# This script is responsible for game over menu.
# Author: Breno Viana
# Version: 21/10/2017
###
extends Node2D

func _ready():
    """ Called every time the node is added to the scene.
		Initialization here. """
    Globals.set("enemy_group", "enemies")
    Globals.set("score", 0)
