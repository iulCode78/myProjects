extends Control
	
var is_paused : bool = false:
	set = set_paused
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		is_paused = !is_paused
		#get_tree().change_scene_to_file("res://Scenes/Pause_Menu.tscn")
		
func set_paused(value : bool) -> void:
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
		
func _on_continue_pressed() -> void:
	is_paused = false

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")

func _on_desktop_pressed():
	get_tree().quit()
