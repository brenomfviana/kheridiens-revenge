###
# This script is responsible for ninja behaviors.
# Author: Breno Viana
# Version: 16/11/2017
###
extends KinematicBody2D

################################################################################

# INFO
const LIFE_BAR_SCALE = 0.3
# Current phase
var current_phase

################################################################################

# Physics constants
const GRAVITY = 2000.0

# Player constants
const SPEED      = 250
const JUMP_FORCE = 750
const MAX_LIFE   = 100

################################################################################

# Ninja states controllers
var deading
var dead
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
	# Initialize states values
	deading    = false
	dead       = false
	stopped    = true
	running    = false
	jumping    = false
	attacking  = false
	sword      = false
	kunai      = false
	invencible = false
	# Initilize movement values
	velocity   = Vector2(0, 0)
	direction  = 0
	# Initialize attributes
	current_life     = MAX_LIFE
	amount_of_kunais = Globals.get("amount_of_kunais")
	score            = Globals.get("score")
	# Get current phase
	current_phase = get_parent().get_name()
	# Connect behavior when finish animation
	get_node("sprite").connect("finished", self, "_on_anim_finished")
	# Connect behavior when finish the time of invencibility
	get_node("invincibility_timer").connect("timeout", self, "_on_invincibility_timer_timeout")
	# Connect behavior when finish the time of death animation
	get_node("deading_timer").connect("timeout", self, "_on_deading_timer_timeout")

func _process(delta):
	""" Called every frame. Update info. """
	# Update info
	var s_life = Vector2((float(current_life) / MAX_LIFE) * LIFE_BAR_SCALE, LIFE_BAR_SCALE)
	get_node("camera/canvas_layer/info/lifebar/life").set_scale(s_life)
	# Update number of lifes
	var nf = get_node("camera/canvas_layer/info/lifebar/number_of_lives")
	nf.set_text("x " + str(Globals.get("number_of_lifes")))
	# Update amount of kunais
	var info = get_node("camera/canvas_layer/info/itens/kunai/amount_of_kunais")
	info.set_text("x " + str(amount_of_kunais))
	# Update score
	var info = get_node("camera/canvas_layer/info/lifebar/score")
	info.set_text(str(score))

func _fixed_process(delta):
	""" Called every frame. Ninja behaviors. """
	# Check if the game is paused
	if(Globals.get("paused")):
		get_node("sprite").stop();
	if(not Globals.get("paused")):
		# Check if is not dead
		if(deading):
			deading = false
			dead    = true
			# Check direction
			if(get_node("sprite").is_flipped_h()):
				get_node("sprite").set_offset(Vector2(-110, 20))
			else:
				get_node("sprite").set_offset(Vector2(120, 20))
			get_node("sprite").play("deading")
			get_node("deading_timer").start()
		elif(not dead):
			# Check if the invencible mode is on
			if(invencible):
				get_node("sprite").set_opacity(0.7)
			# Gravity
			velocity.y += GRAVITY * delta
			# Horizontal move
			velocity.x = lerp(velocity.x, SPEED * direction, 0.1)
			var motion = velocity * delta
			move(motion)
			# Check if the player is colliding
			if(is_colliding()):
				jumping = false
				velocity.y = 0
				# Check enemy collision
				var entity = get_collider()
				if(entity.is_in_group(Globals.get("enemy_group"))):
					if(not attacking and not invencible):
						current_life -= entity.DAMAGE
						# Check life
						if(current_life <= 0):
							deading = true
						else:
							invencible = true
							get_node("invincibility_timer").start()
				if(entity.get_parent().get_name().is_subsequence_of("abyss")):
					deading = true
				# Movement
				var normal = get_collision_normal()
				motion     = normal.slide(motion)
				velocity   = normal.slide(velocity)
				move(motion)
			# Choose the direction
			if(direction == 1):
				get_node("sprite").set_flip_h(false)
			elif(direction == -1):
				get_node("sprite").set_flip_h(true)
			# Run respective animation
			if(attacking):
				# With a sword
				if(sword):
					get_node("sprite").play("attacking_sword")
					get_node("sound").play("sword")
					# Check direction
					if(get_node("sprite").is_flipped_h()):
						get_node("sword").set_pos(Vector2(-50, 0))
						get_node("sprite").set_offset(Vector2(-110, 20))
					else:
						get_node("sword").set_pos(Vector2(50, 0))
						get_node("sprite").set_offset(Vector2(120, 20))
					sword = false
				# With a kunai
				elif(kunai and (amount_of_kunais > 0)):
					# Use a kunai
					amount_of_kunais -= 1;
					# Run animation
					get_node("sprite").play("attacking_kunai")
					# Create kunai
					add_child(load("res://scenes/player/kunai.tscn").instance())
					kunai = false
			elif(jumping):
				get_node("sprite").play("jumping")
			elif(running):
				get_node("sprite").play("running")
			elif(not running):
				get_node("sprite").play("stopped")

func _on_anim_finished():
	""" Called when an animation finishes. """
	# Next animation
	get_node("sprite").play("stopped")
	# End attaking
	attacking = false
	# Reset animation
	get_node("sword").set_pos(Vector2(0, 0))
	# Set default values
	get_node("sprite").set_offset(Vector2(0, 0))

func _input(event):
	""" Get user input and set the values corresponding to the expected
		behavior. """
	# Check event type
	if(event.type == InputEvent.KEY):
		# Check if the game is not paused
		if(not Globals.get("paused")):
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
				if(event.is_action_pressed("attack_kunai") 
					and (Globals.get("amount_of_kunais") > 0)):
						attacking = true
						kunai     = true
			if(event.is_action_released("attack_sword")):
				sword = false
		if(event.is_action_pressed("ui_accept")):
			Globals.set("paused", not Globals.get("paused"))

func _on_deading_timer_timeout():
	""" Called when the dead animation time ends. """
	Globals.set("number_of_lifes", Globals.get("number_of_lifes") - 1)
	# Check number of lifes
	if(Globals.get("number_of_lifes") <= 0):
		get_tree().change_scene("res://scenes/screens/game_over.tscn")
	else:
		get_tree().change_scene("res://scenes/levels/" + current_phase + ".tscn")
	dead = false

func _on_invincibility_timer_timeout():
	""" Called when the invincibility time ends. """
	invencible = false
	get_node("sprite").set_opacity(1)