extends Node

var GAME_SCALE: float = 4.0
var MENU_SCALE: float = 1.0
var DEBUG_SCALE: float = 1.0

func change_scene_with_scale(scene_path: String, target_scale: float):
	var new_scene = load(scene_path).instantiate()
	
	# Remove cena atual
	var old_scene = get_tree().current_scene
	if old_scene:
		get_tree().root.remove_child(old_scene)
		old_scene.queue_free()
	
	# Adiciona nova cena com escala
	new_scene.scale = Vector2(target_scale, target_scale)
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene

func go_to_game():
	change_scene_with_scale("res://scenes/main.tscn", GAME_SCALE)

func go_to_main_menu():
	change_scene_with_scale("res://Menus/main_menu.tscn", MENU_SCALE)

#func go_to_debug():
	#change_scene_with_scale("res://debug_menu.tscn", DEBUG_SCALE)
