extends Node2D

signal toggled

var casos_path = load("res://scenes/caso_de_teste.tscn")
var casos := []
var open := true

func add_caso() -> void:
	var num_casos = len(casos)
	# Adicionando o novo método
	var new_caso = casos_path.instantiate()
	new_caso.rename("Caso de Teste " + str(num_casos + 1))
	new_caso.position = Vector2(0, (num_casos + 1) * 30)
	casos.append(new_caso)
	add_child(new_caso)
	if not open:
		new_caso.visible = false

	# Alterando a linha
	var sprite_width = 843
	$Linha.scale = Vector2(17, 30 * num_casos + 21) / sprite_width

func _ready() -> void:
	$Seta._on_button_down()
	_on_seta_button_down()
	add_caso()

func _on_seta_button_down() -> void:
	if open:
		open = false
		$Linha.visible = false
		for caso in casos:
			caso.visible = false
	else:
		open = true
		$Linha.visible = true
		for caso in casos:
			caso.visible = true

	emit_signal("toggled")

func rename(novo_nome: String) -> void:
	$Label.text = novo_nome

func get_height() -> int:
	if open:
		return 30 * (len(casos) + 1)
	else:
		return 30
