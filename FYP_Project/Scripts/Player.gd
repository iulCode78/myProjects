extends CharacterBody2D

@export var speed: float = 200
@export var accel: float = 30
var a = 0

@onready var ani_tree = $AnimationTree
@onready var state_machine = ani_tree.get("parameters/playback")

var input = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	#Left, Right, Up, and Down
	var direction: Vector2 = Input.get_vector("LEFT","RIGHT","UP","DOWN")
	
	velocity.x = move_toward(velocity.x, speed * direction.x, accel)
	velocity.y = move_toward(velocity.y, speed * direction.y, accel)
	
	update_animation(direction)
	move_and_slide()
	new_state()
	
	#Dash Ability
	if Input.is_action_just_pressed("DASH"):
		dash()

func update_animation(move_input : Vector2):
	if(move_input != Vector2.ZERO):
		ani_tree.set("parameters/Move/blend_position", move_input)
		ani_tree.set("parameters/Idle/blend_position", move_input)
		ani_tree.set("parameters/Dash/blend_position", move_input)

func new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("Move")
	if(Input.is_action_just_pressed("DASH")):
		state_machine.travel("Dash")
	else:
		state_machine.travel("Idle")
		
func dash():
	speed = 600
	$Timer.start()
	
func _on_timer_timeout():
	speed = 200
