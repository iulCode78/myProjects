extends Control

#When pressed, you exit the options menu and go back to the main menu
func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")

#When toggled, the window is set to fullscreen
func _on_fullscreen_toggled(toggled_on):
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
