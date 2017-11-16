###
# This script is responsible for the completion of levels.
# Author: Breno Viana
# Version: 16/11/2017
###
extends Area2D

func _ready():
	""" Called every time the node is added to the scene.
		Initialization here. """
	# Connect behavior when entering the body
	connect("body_enter", self, "_on_body_enter")

func _on_body_enter(body):
	""" Called when a body entered the crate. """
	# Check if the ninja enter the arrow sign
	if(body.get_name() == "ninja"):
		get_tree().change_scene("res://scenes/screens/credits.tscn")
