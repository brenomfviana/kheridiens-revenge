###
# This script is responsible for kunai behaviors.
# Author: Breno Viana
# Version: 16/11/2017
###
extends Area2D

################################################################################

# Kunai damage
var damage
# Kunai movement
var direction
var position

################################################################################

func _ready():
	""" Called every time the node is added to the scene.
		Initialization here. """
	# Initialize values
	damage = 10
	# Check direction
	if(get_parent().get_node("sprite").is_flipped_h()):
		direction = -1
		get_node("sprite").set_flip_v(true)
	else:
		direction =  1
		get_node("sprite").set_flip_v(false)
	# Set position
	position    = get_parent().get_pos()
	position.x += 40 * direction
	set_pos(position)
	# Kunai becomes independent of the ninja
	set_as_toplevel(true)
	# Connect behavior when entering the body
	connect("body_enter", self, "_on_body_enter")
	# Set processes
	set_fixed_process(true)

func _fixed_process(delta):
	""" Called every frame. """
	# Check if the game is not paused
	if(not Globals.get("paused")):
		# Kunai movement
		var move = get_pos()
		move.x  += 10 * direction
		set_pos(move)

func _on_body_enter(body):
	""" Called when a body entered the crate. """
	# Check if the kunai hit a enemy
	if(body.is_in_group(Globals.get("enemy_group"))):
		# Check if the enemy is not dead
		if(not body.dead):
			body.under_attack = true
			body.current_life -= damage
			# Check if the enemy has died
			if(body.current_life <= 0):
				get_parent().score += body.PONTUATION
	# Delete this kunai
	queue_free()