extends Node2D
class_name Leaf

var height = 30

func rename(new_name: String) -> void:
	$Label.text = new_name

func get_height() -> int:
	return height
