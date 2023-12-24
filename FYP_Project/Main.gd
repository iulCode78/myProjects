extends Node2D

@onready var pause_menu = $Pause_Menu
var paused = false

#var level_time = 0.0

#func _ready():
	#var t = Time.get_msec()

func _process(delta):
	if Input.is_action_pressed('Pause'):
		get_tree().paused = not get_tree().paused
		%Pause_Menu.visible = not $Pause_Menu.visible
		#get_tree().change_scene_to_file("res://Scenes/Pause_Menu.tscn")
	
func pauseMenu():
	if paused:
		hide()
		Engine.time_scale = 1
	else:
		show()
		Engine.time_scale = 0
	
	paused = !paused
