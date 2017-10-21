###
# This script is responsible for kunai behaviors.
# Author: Breno Viana
# Version: 20/10/2017
###
extends Area2D

# Kunai damage
var damage
# Kunai movement
var direction
var position

func _ready():
	""" Called every time the node is added to the scene.
		Initialization here. """
	damage    = 10
	# Check direction
	if(get_parent().get_node("sprite").is_flipped_h()):
		direction = -1
	else:
		direction = 1
	# Set direction
	if(direction == 1):
		get_node("sprite").set_flip_v(false)
	elif(direction == -1):
		get_node("sprite").set_flip_v(true)
	# Set position
	position  = get_parent().get_pos()
	position.x += 40 * direction
	set_pos(position)
	# Set processes
	set_fixed_process(true)
	set_as_toplevel(true)
	connect("body_enter", self, "_on_body_enter")

func _fixed_process(delta):
	""" . """
	# Kunai movement
	var move = get_pos()
	move.x += 10 * direction
	set_pos(move)

func _on_body_enter(body):
	""" Called when a body entered the crate. """
	# Check if the ninja enter the crate
	if(body.is_in_group(Globals.get("enemy_group"))):
		# Check if is not dead
		if(not body.dead):
			Globals.set("score", Globals.get("score") + body.PONTUATION)
			body.dead = true
	# Delete kunai
	queue_free()