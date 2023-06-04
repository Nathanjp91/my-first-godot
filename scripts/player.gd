extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -800.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var GRAVITY = 0
@export var TERMINAL_VELOCITY = 1000

func _physics_process(delta):
	
	var vertical_direction = Input.get_axis("move_up", "move_down")
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	velocity.x = SPEED * horizontal_direction
	velocity.y = SPEED * vertical_direction
	move_and_slide()
