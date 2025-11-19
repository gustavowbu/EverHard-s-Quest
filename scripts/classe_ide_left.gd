extends Node2D

func _on_seta_button_down() -> void:
	if $Metodo.visible:
		$Metodo.visible = false
		$Metodo2.visible = false
		$Metodo3.visible = false
		$Metodo4.visible = false
		$Linha.visible = false
	else:
		$Metodo.visible = true
		$Metodo2.visible = true
		$Metodo3.visible = true
		$Metodo4.visible = true
		$Linha.visible = true
