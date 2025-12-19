extends Area2D

@export var main_scene: String = "res://scenes/main_area.tscn"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file(main_scene)
