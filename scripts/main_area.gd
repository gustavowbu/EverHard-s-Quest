extends Node2D

func _ready():
	global.player_position = Vector2.ZERO

func _on_door_to_forest_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		global.current_scene = "res://scenes/floresta_da_abstracao.tscn"
		get_tree().change_scene_to_file(global.current_scene)

func _on_door_to_kingdom_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		global.current_scene = "res://scenes/reino_da_heranca.tscn"
		get_tree().change_scene_to_file(global.current_scene)
		
func _on_door_to_cavern_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		global.current_scene = "res://scenes/caverna_do_encapsulamento.tscn"
		get_tree().change_scene_to_file(global.current_scene)
		
func _on_door_to_river_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		global.current_scene = "res://scenes/rio_do.tscn"
		get_tree().change_scene_to_file(global.current_scene)
