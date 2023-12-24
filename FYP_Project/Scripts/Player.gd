extends CharacterBody2D

@export var speed: float = 200
@export var accel: float = 30
var a = 0

var input = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	#Left, Right, Up, and Down
	var direction: Vector2 = Input.get_vector("LEFT","RIGHT","UP","DOWN")
	
	velocity.x = move_toward(velocity.x, speed * direction.x, accel)
	velocity.y = move_toward(velocity.y, speed * direction.y, accel)
	
	move_and_slide()
	
	$AnimationTree.set("parameters/Idle/blend_position", velocity)
	
	#Dash Ability
	if Input.is_action_just_pressed("DASH"):
		dash()
		
	
	
			
func dash():
	speed = speed * 4
	$Timer.start()
	
func _on_timer_timeout():
	speed = 200
