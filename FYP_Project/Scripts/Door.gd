extends Area2D

#signal leaving_level

const file_start = "res://Scenes/Level_"

func _on_body_entered(body):
	#emit_signal("leaving_level")
	if body.is_in_group("Player"):
		var current_scene_file = get_tree().current_scene.scene_file_path
		var next_level_number = current_scene_file.to_int() + 1
		
		var next_level_path = file_start + str(next_level_number) + ".tscn"
		get_tree().change_scene_to_file(next_level_path)
