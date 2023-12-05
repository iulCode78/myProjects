extends Control

@export var Game_Manager : GameManager

func _ready():
	hide()
	Game_Manager.connect("toggle_game_paused", on_game_manager_paused)
	
func _process(delta):
	pass
	
func on_game_manager_paused(is_paused : bool):
	if(is_paused):
		show()
	else:
		hide()
	
func _on_continue_pressed():
	Game_Manager.game_paused = false

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")
	Game_Manager.game_paused = false

func _on_desktop_pressed():
	get_tree().quit()
