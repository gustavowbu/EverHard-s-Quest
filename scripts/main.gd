extends Node2D

func _ready():
	$FadeLayer.fade_in()
	pass

func _process(delta):
	change_scene()

func _on_cliffside_trans_point_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = true


func _on_cliffside_trans_point_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = true
		
func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
			global.finish_changescenes()
