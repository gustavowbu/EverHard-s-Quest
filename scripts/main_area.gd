extends Node2D

func _ready():
	global.player_position = Vector2.ZERO

func _on_door_to_forest_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.current_scene = "res://scenes/floresta_da_abstracao.tscn"
		get_tree().change_scene_to_file(global.current_scene)
