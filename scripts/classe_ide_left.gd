extends Node2D

var metodo_path = load("res://scenes/metodo_ide_left.tscn")
var metodos := []
var open = true

func _ready():
	add_metodo()
	add_metodo()
	add_metodo()
	add_metodo()

func update_positions() -> void:
	var sprite_width = 843

	# Ajustando a altura dos métodos
	var metodos_height = 0
	for metodo in metodos:
		metodo.position = Vector2(0, metodos_height + 30)
		metodos_height += metodo.get_height()

	# Alterando a linha
	$Linha.scale = Vector2(17, metodos_height - 9) / sprite_width

func add_metodo() -> void:
	# Adicionando o novo método
	var new_metodo = metodo_path.instantiate()
	new_metodo.rename("Método " + str(len(metodos) + 1))
	new_metodo.toggled.connect(update_positions)
	metodos.append(new_metodo)
	add_child(new_metodo)

	# Atualizando posições
	update_positions()

func _on_seta_button_down() -> void:
	if open:
		open = false
		$Linha.visible = false
		for metodo in metodos:
			metodo.visible = false
	else:
		open = true
		$Linha.visible = true
		for metodo in metodos:
			metodo.visible = true
