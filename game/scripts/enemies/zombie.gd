###
# This script is responsible for zombie behaviors.
# Author Breno Viana
# Version: 16/11/2017
###
extends KinematicBody2D

################################################################################

# Physics constants
const GRAVITY = 2000.0
# Zombie constants
const SPEED     = 15
const MAX_STEPS = 120
const DAMAGE    = 5
const PONTUATION = 10

################################################################################

# Ninja states controllers
var stopped
var walking
var under_attack
var dead
# Zombie movement
var initial_position
var steps
var velocity
var direction
# Zombie attributes
var current_life

################################################################################

func _ready():
	""" Called every time the node is added to the scene.
		Initialization here. """
	# Set processes
	set_process(true)
	# Initialize states values
	stopped      = false
	walking      = false
	under_attack = false
	dead         = false
	# Initilize movement values
	direction = 1
	steps     = 0
	# Initialize attributes
	current_life = 50
	initial_position = get_pos()
	velocity  = Vector2(0, 0)
	# Add to enemies group
	add_to_group(Globals.get("enemy_group"))
	# Connect behavior when finish the time of death animation
	get_node("under_attack_timer").connect("timeout", self, "_on_under_attack_timer_timeout")

func _process(delta):
	# Check if the game is paused
	if(Globals.get("paused")):
		get_node("sprite").stop();
	if(not Globals.get("paused")):
		# Check if the zombis is under attack
		if(under_attack):
			get_node("sprite").set_modulate(Color(1, 0.5, 0.5))
			get_node("under_attack_timer").start()
			under_attack = false
		# Check if the zombie is not dead
		if(current_life <= 0):
			dead = true
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
			if(get_node("sprite").is_flipped_h()):
				get_node("sprite").set_offset(Vector2(-180, 45))
			else:
				get_node("sprite").set_offset(Vector2(180, 45))
			get_node("sprite").play("dead")
			remove_child(get_node("hitbox"))

func _on_under_attack_timer_timeout():
	""" Called when the under attack time ends. """
	get_node("sprite").set_modulate(Color(1, 1, 1))