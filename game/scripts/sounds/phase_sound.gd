###
# This script is responsible for sound.
# Author: Breno Viana
# Version: 21/10/2017
###
extends SamplePlayer2D


func _ready():
	""" Called every time the node is added to the scene.
		Initialization here. """
	play("intro")
