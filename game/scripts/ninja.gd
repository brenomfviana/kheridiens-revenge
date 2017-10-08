###
# This script is responsible for ninja behaviors.
# Author Breno Viana
###
extends KinematicBody2D

# Constants
const GRAVITY = 2000.0

# Player
const SPEED      = 250
const JUMP_FORCE = 700

# Animations
var running
var stopped
var jumping
# Ninja movement
var velocity
var direction

func _ready():
	""" Called every time the node is added to the scene.
	Initialization here. """
	set_process(true)
	set_fixed_process(true)
	set_process_input(true)
	# Initialize values
	stopped   = true
	running   = false
	jumping   = false
	velocity  = Vector2(0, 0)
	direction = 0

func _fixed_process(delta):
	""" Called every frame. """
	# Ninja Attack
	#
	# Ninja movement and jump
	# Gravity
	velocity.y += GRAVITY * delta
	# Horizontal move
	velocity.x = lerp(velocity.x, SPEED * direction, 0.1)
	var motion = velocity * delta
	move(motion)
	# Cehck if the player is on the ground
	if(is_colliding()):
		jumping = false
		velocity.y = 0
		var normal = get_collision_normal()
		motion = normal.slide(motion)
		velocity = normal.slide(velocity)
		move(motion)
	# Animation
	if(jumping && velocity.y != 0):
		get_node("player_sprite").play("jumping")
	elif(running):
		get_node("player_sprite").play("running")
	#elif(stopped || velocity.x == 0):
	else:
		get_node("player_sprite").play("stopped")

func _input(event):
	""" . """
	# Check event type
	if(event.type == InputEvent.KEY):
		if(event.is_action_pressed("ui_right")):
			get_node("player_sprite").set_flip_h(false)
			direction = 1
			running =  true
			stopped = false
		if(event.is_action_released("ui_right")):
			direction = 0
			running = false
			stopped = true
		if(event.is_action_pressed("ui_left")):
			get_node("player_sprite").set_flip_h(true)
			direction = -1
			running =  true
			stopped = false
		if(event.is_action_released("ui_left")):
			direction = 0
			running = false
			stopped = true
		# Check if is not jumping
		if(!jumping):
			if(event.is_action_pressed("ui_up")):
				velocity.y -= JUMP_FORCE
				#running = false
				stopped = false
				jumping = true
		if(event.is_action_pressed("ui_down")):
			pass