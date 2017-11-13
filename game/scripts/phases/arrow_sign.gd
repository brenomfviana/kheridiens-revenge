###
# This script is responsible for sword behaviors.
# Author: Breno Viana
# Version: 20/10/2017
###
extends Area2D

func _ready():
	""" Called every time the node is added to the scene.
		Initialization here. """
	connect("body_enter", self, "_on_body_enter")

func _on_body_enter(body):
	""" Called when a body entered the crate. """
	# Check if the ninja enter the crate
	if(body.get_name() == "ninja"):
		get_tree().change_scene("res://scenes/menu/credits.tscn")
