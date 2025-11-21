extends Node2D
class_name Leaf

var height = 30

func rename(new_name: String) -> void:
	$Label.text = new_name

func get_height() -> int:
	return height

func update() -> void:
	pass

func alterar_icone(path) -> void:
	$Icon.texture = load(path)
	$Icon.scale = Vector2(1, 1)
