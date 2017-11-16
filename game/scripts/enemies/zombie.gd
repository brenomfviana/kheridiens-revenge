###
# This script is responsible for zombie behaviors.
# Author Breno Viana
# Version: 13/11/2017
###
extends KinematicBody2D

# Physics constants
const GRAVITY = 2000.0
# Zombie constants
const SPEED     = 15
const MAX_STEPS = 120
const DAMAGE    = 5
const PONTUATION = 10

# Animations
var initial_position
var steps
var stopped
var walking
var dead
# Zombie movement
var velocity
var direction

func _ready():
	""" Called every time the node is added to the scene.
		Initialization here. """
	# Set processes
	set_process(true)
	# Initialize values
	initial_position = get_pos()
	velocity  = Vector2(0, 0)
	direction = 1
	steps     = 0
	dead      = false
	stopped   = false
	walking   = false
	# Add to enemies group
	add_to_group("enemies")

func _process(delta):
	# Check if the game is paused
	if(Globals.get("paused")):
		get_node("sprite").stop();
	if(not Globals.get("paused")):
		# Check if the zombie is not dead
		if(not dead):
			# Zombie movement
			if(get_pos().x <= initial_position.x and direction == -1):
				get_node("sprite").set_flip_h(false)
				direction = 1
			elif(get_pos().x >= (initial_position.x + MAX_STEPS)
					and direction == 1):
				get_node("sprite").set_flip_h(true)
				direction = -1
			# Gravity
			velocity.y += GRAVITY * delta
			get_node("sprite").play("walking")
			velocity.x = lerp(velocity.x, SPEED * direction, 0.1)
			var motion = velocity * delta
			move(motion)
			if(is_colliding()):
				var normal = get_collision_normal()
				velocity = normal.slide(velocity)
				var motion = velocity * delta
				move(motion)
		elif(has_node("hitbox")):
			get_node("sprite").play("dead")
			remove_child(get_node("hitbox"))
			get_node("sprite").set_offset(Vector2(0, 50))
