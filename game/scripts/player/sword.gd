###
# This script is responsible for sword behaviors.
# Author: Breno Viana
# Version: 16/11/2017
###
extends Area2D

################################################################################

# Sword damage
var damage

################################################################################

func _ready():
	""" Called every time the node is added to the scene.
		Initialization here. """
	# Initialize values
	damage = 25
	# Connect behavior when entering the body
	connect("body_enter", self, "_on_body_enter")

func _on_body_enter(body):
	""" Called when a body entered the crate. """
	# Check if the kunai hit a enemy
	if(body.is_in_group(Globals.get("enemy_group"))):
		# Check if the enemy is not dead
		if(not body.dead):
			Globals.set("score", Globals.get("score") + body.PONTUATION)
			body.current_life -= damage
