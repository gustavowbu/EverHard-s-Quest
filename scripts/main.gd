extends Node2D

func _ready():
	$FadeLayer.fade_in()
	pass

func _on_cliffside_trans_point_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.current_scene = "res://scenes/cliff_side.tscn"
		get_tree().change_scene_to_file(global.current_scene)
