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
	set_fixed_process(true)

func _fixed_process(delta):
	# Called every frame
	var right = 0
	var left  = 0
	var up    = 0
	var down  = 0
	# Check if the right key was pressed
	if Input.is_action_pressed("ui_right"):
		right = 1
	# Check if the left key was pressed
	if Input.is_action_pressed("ui_left"):
		left = -1
	# Check if the right key was pressed
	if Input.is_action_pressed("ui_up"):
		up = -1
	# Check if the left key was pressed
	if Input.is_action_pressed("ui_down"):
		down = 1
	# Update position
	var body = get_node("KinematicBody2D")
	body.move_to(get_pos() + Vector2(speed, 0) * delta * (right + left)
		+ Vector2(0, speed) * delta * (up + down))