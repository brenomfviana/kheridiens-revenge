extends KinematicBody2D

# Constants
const GRAVITY   = 2000.0
const SPEED     = 15
const MAX_STEPS = 120

# Animations
var initial_position
var steps
var stopped
var walking
# Zombie movement
var velocity
var direction

var n = 0

func get_name():
	return ("zombie")
	
func _ready():
	n+=1;
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	set_fixed_process(true)

	initial_position = get_pos()
	velocity  = Vector2(0, 0)
	direction = 1
	steps = 0
	pass
	
func _fixed_process(delta):
	if(is_colliding()):
		var entity = get_collider()
		if(entity.get_name() == 'ninja'):
			print('zombie tocou no ninja!')

func _process(delta):
	#
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
	pass