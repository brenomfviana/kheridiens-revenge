###
# This script is responsible for ninja behaviors.
# Author: Breno Viana
# Version: 20/10/2017
###
extends KinematicBody2D

################################################################################

# INFO
const LIFE_BAR_SCALE = 0.3

################################################################################

# Physics constants
const GRAVITY = 2000.0

# Player constants
const SPEED      = 250
const JUMP_FORCE = 700
const MAX_LIFE   = 100

################################################################################

# Current phase
var current_phase

# Ninja states controllers
var running
var stopped
var jumping
var attacking
var kunai
var sword
var invencible

# Ninja movement
var velocity
var direction

# Ninja attributes
var current_life
var number_of_lifes
var amount_of_kunais
var score

################################################################################

func _ready():
	""" Called every time the node is added to the scene.
		Initialization here. """
	# Set processes
	set_process(true)
	set_fixed_process(true)
	set_process_input(true)
	# Initialize values
	stopped    = true
	running    = false
	jumping    = false
	attacking  = false
	sword      = false
	kunai      = false
	invencible = false
	velocity  = Vector2(0, 0)
	direction = 0
	current_life     = MAX_LIFE
	number_of_lifes  = 3
	amount_of_kunais = 20
	score = 0
	# Get current phase
	current_phase = get_parent().get_name()
	#
	get_node("sprite").connect("finished", self, "_on_anim_finished")

func _process(delta):
	""" Called every frame. Update info. """
	# Update info
	if(current_life <= 0):
		number_of_lifes -= 1
		# Check number of lifes
		if(number_of_lifes == 0):
			get_tree().change_scene("res://scenes/game_over.tscn")
		else:
			get_tree().change_scene("res://scenes/" + current_phase + ".tscn")
	else:
		var s_life = Vector2((float(current_life) / MAX_LIFE) * LIFE_BAR_SCALE, LIFE_BAR_SCALE)
		get_node("camera/canvas_layer/info/lifebar/life").set_scale(s_life)
	# Update number of lifes
	var nf = get_node("camera/canvas_layer/info/lifebar/number_of_lives")
	nf.set_text("x " + str(number_of_lifes))
	# Update amount of kunais
	var info = get_node("camera/canvas_layer/info/itens/kunai/amount_of_kunais")
	info.set_text("x " + str(amount_of_kunais))
	# Update score
	var info = get_node("camera/canvas_layer/info/lifebar/score")
	info.set_text(str(Globals.get("score")))

func _fixed_process(delta):
	""" Called every frame. Ninja behaviors. """
	if(invencible):
		pass
	# Gravity
	velocity.y += GRAVITY * delta
	# Horizontal move
	velocity.x = lerp(velocity.x, SPEED * direction, 0.1)
	var motion = velocity * delta
	move(motion)
	# Check if the player is colliding
	if(is_colliding()):
		# Check enemy collision
		var entity = get_collider()
		if(entity.get_name() == "zombie"):
			if(not attacking and not invencible):
				current_life -= entity.DAMAGE
				invencible = true
		if(entity.get_parent().get_name().is_subsequence_of("floor")):
			current_life = 0
		# Can't jump
		jumping = false
		velocity.y = 0
		# Movement
		var normal = get_collision_normal()
		motion     = normal.slide(motion)
		velocity   = normal.slide(velocity)
		move(motion)
	# Run respective animation
	# Set default values
	get_node("sprite").set_offset(Vector2(0, 0))
	# Choose the direction
	if(direction == 1):
		get_node("sprite").set_flip_h(false)
	elif(direction == -1):
		get_node("sprite").set_flip_h(true)
	# Run respective animation
	if(attacking):
		# Prepare ninja attack
		# With a sword
		if(sword):
			get_node("sprite").play("attacking_sword")
			# Check direction
			if(get_node("sprite").is_flipped_h()):
				get_node("sword").set_pos(Vector2(-50, 0))
				get_node("sprite").set_offset(Vector2(-110, 20))
			else:
				get_node("sword").set_pos(Vector2(50, 0))
				get_node("sprite").set_offset(Vector2(120, 20))
		# With a kunai
		elif(kunai and (amount_of_kunais > 0)):
			# Use a kunai
			amount_of_kunais -= 1
			# Run animation
			get_node("sprite").play("attacking_kunai")
			# Create kunai
			add_child(load("res://scenes/player/kunai.tscn").instance())
			kunai = false
	else:
		# Reset animation
		get_node("sword").set_pos(Vector2(0, 0))
		if(jumping && velocity.y != 0):
			get_node("sprite").play("jumping")
		elif(running):
			get_node("sprite").play("running")
		else:
			get_node("sprite").play("stopped")

func _input(event):
	""" Get user input and set the values corresponding to the expected
		behavior. """
	# Check event type
	if(event.type == InputEvent.KEY):
		# Check key pressed
		if(event.is_action_pressed("ui_right")):
			direction = 1
			running   = true
			stopped   = false
		if(event.is_action_released("ui_right")):
			direction = 0
			running   = false
			stopped   = true
		if(event.is_action_pressed("ui_left")):
			direction = -1
			running   = true
			stopped   = false
		if(event.is_action_released("ui_left")):
			direction = 0
			running   = false
			stopped   = true
		# Check if is not jumping
		if(not jumping):
			if(event.is_action_pressed("ui_up")):
				velocity.y -= JUMP_FORCE
				stopped = false
				jumping = true
		# Check if is not attacking
		if(not attacking):
			if(event.is_action_pressed("attack_sword")):
				attacking = true
				sword     = true
			if(event.is_action_pressed("attack_kunai")):
				attacking = true
				kunai     = true
		if(event.is_action_released("attack_sword")):
			attacking = false
			sword     = false

func _on_anim_finished():
	get_node("sprite").play("stopped")
	attacking = false