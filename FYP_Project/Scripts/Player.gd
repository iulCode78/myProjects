extends CharacterBody2D

@export var speed : float = 100

var input = Vector2.ZERO

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("RIGHT") - Input.get_action_strength("LEFT"),
		Input.get_action_strength("DOWN") - Input.get_action_strength("UP")
	)
	
	velocity = input_direction * speed
	move_and_slide()
