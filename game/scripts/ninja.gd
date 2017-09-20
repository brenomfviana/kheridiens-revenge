#!
# This script is responsible for ninja behaviors.
#
extends Node2D

# Ninja speed
var speed = 50
var run_speed = 100

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	pass

func _process(delta):
	# Called every frame
	var right = 0
	var left  = 0
	# Check if the right key was pressed
	if Input.is_action_pressed("ui_right"):
		right = 1
	# Check if the left key was pressed
	if Input.is_action_pressed("ui_left"):
		left = -1
	# Update position
	set_pos(get_pos() + Vector2(speed, 0) * delta * (right + left))
	pass