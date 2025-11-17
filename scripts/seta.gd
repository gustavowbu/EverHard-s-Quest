extends Button

var off = false

func _on_button_down() -> void:
	if off:
		$Sprite2D.rotation = 0
		off = false
	else:
		$Sprite2D.rotation = -3.1415 / 2
		off = true
