extends CanvasLayer


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_area.tscn")

func _on_achievements_pressed() -> void:
	pass # Replace with function body.

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_quit_game_pressed() -> void:
	get_tree().quit()
