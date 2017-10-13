###
# This script is responsible for ninja behaviors.
# Author Breno Viana
###
extends KinematicBody2D

# Physics constants
const GRAVITY = 2000.0
# Player constants
const SPEED      = 250
const JUMP_FORCE = 700

# Animation controllers
var running
var stopped
var jumping
var attacking
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
	attacking = false
	velocity  = Vector2(0, 0)
	direction = 0

func _fixed_process(delta):
	""" Called every frame. """
	# Ninja movement and jump
	# Gravity
	velocity.y += GRAVITY * delta
	# Horizontal move
	velocity.x = lerp(velocity.x, SPEED * direction, 0.1)
	var motion = velocity * delta
	move(motion)
	# Check if the player is on the ground

	if(is_colliding()):
		var entity = get_collider()
		if(entity.get_name() == 'zombie'):
			print('morreu!')
		# Can't jump
		jumping = false
		velocity.y = 0
		var normal = get_collision_normal()
		motion     = normal.slide(motion)
		velocity   = normal.slide(velocity)
		move(motion)
	# Run respective animation
	get_node("player_sprite").set_offset(Vector2(0, 0))
	if(jumping && velocity.y != 0):
		get_node("player_sprite").play("jumping")
	elif(running):
		get_node("player_sprite").play("running")
	elif(attacking):
		get_node("player_sprite").play("attacking")
		# Check direction
		if(get_node("player_sprite").is_flipped_h()):
			get_node("player_sprite").set_offset(Vector2(-110, 20))
		else:
			get_node("player_sprite").set_offset(Vector2(120, 20))
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
		# Check if is not attaking
		if(!attacking):
			if(event.is_action_pressed("ninja_attack")):
				attacking = true
		if(event.is_action_released("ninja_attack")):
			attacking = false
		if(event.is_action_pressed("ui_down")):
			pass