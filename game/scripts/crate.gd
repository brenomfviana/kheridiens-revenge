###
# This script is responsible for crate behaviors.
# Author: Breno Viana
# Version: 16/11/2017
###
extends Area2D

# Already opened
var already_opened
# On the crate
var on_the_crate
# Entity over the crate
var entity

func _ready():
	""" Called every time the node is added to the scene.
		Initialization here. """
	# Set processes
	set_process(true)
	set_process_input(true)
	connect("body_enter", self, "_on_body_enter")
	connect("body_exit",  self,  "_on_body_exit")
	# Initialize values
	already_opened = false
	on_the_crate   = false
	entity         = null

func _process(delta):
	""" Called every frame. """
	# Chek if the crate was opened
	if(already_opened):
		get_node("sprite").set_modulate(Color(0.39, 0.39, 0.39))

func _input(event):
	""" Get user input and accomplish the respective behavior. """
	# Check event type
	if(event.type == InputEvent.KEY):
		# Check key pressed
		if(event.is_action_pressed("ui_down") and (not already_opened)
			and on_the_crate):
				already_opened = true
				entity.amount_of_kunais += 5

func _on_body_enter(body):
	""" Called when a body entered the crate. """
	# Check if the ninja enter the crate
	if(body.get_name() == "ninja"):
		on_the_crate = true
		entity       = body

func _on_body_exit(body):
	""" Called when a body exited the crate. """
	# Check if the ninja exit the crate
	if(body.get_name() == "ninja"):
		on_the_crate = false
		entity       = null