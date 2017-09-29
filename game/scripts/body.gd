extends KinematicBody2D

# Gravity
const GRAVITY = 2
# Ninja's speed
const NORMAL_SPEED = 10
const SPEED_TO_RUN = 50

func _ready():
	""" Called every time the node is added to the scene.
	Initialization here. """
	set_process(true)
	set_fixed_process(true)

func _fixed_process(delta):
	""" Called every frame. """
	# Ninja Attack
	#
	# Ninja movement
	move()

func move():
	""" Ninja movement. """
	var movement = Vector2(0, 0)
	# Check if the keys pressed
	if Input.is_action_pressed("ui_right"):
		movement.x += NORMAL_SPEED
		get_node("body/sprite").set_flip_h(false)
	if Input.is_action_pressed("ui_left"):
		movement.x -= NORMAL_SPEED
		get_node("body/sprite").set_flip_h(true)
	if Input.is_action_pressed("ui_up"):
		movement.y -= NORMAL_SPEED
	if Input.is_action_pressed("ui_down"):
		movement.y += NORMAL_SPEED
	# Check collision
	if (!get_node("body").is_colliding()):
		# Update position
		# get_node("body").move(self.get_pos() + movement)
		pass
	else:
		print(true)