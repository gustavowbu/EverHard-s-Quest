extends Node2D
class_name Dropdown

signal toggled
var open = true
var height = 30
var elements := []
@export var leaf_path = load("res://scenes/Dropdown/Leaf.tscn")
@export var dropdown_path = load("res://scenes/Dropdown/Dropdown.tscn")

func _ready():
	$Linha.position = Vector2(4, 28)
	$Seta.button_down.connect(_on_seta_button_down)
	update()

func clear() -> void:
	for element in elements:
		element.queue_free()
	elements = []

func rename(new_name: String) -> void:
	$Label.text = new_name

func get_height() -> int:
	if open:
		var elements_height = 0
		for element in elements:
			elements_height += element.get_height()
		return elements_height + height
	else:
		return height

func update() -> void:
	var sprite_height = 30

	# Ajustando a altura dos métodos
	var cumulative_height = 0
	for element in elements:
		element.update()
		element.position = Vector2(12, cumulative_height + height)
		cumulative_height += element.get_height()

	# Alterando a linha
	$Linha.scale = Vector2(1, float(max(0, cumulative_height - 9)) / sprite_height)

func add_dropdown(element_name: String) -> Dropdown:
	# Adicionando o novo element
	var new_element = dropdown_path.instantiate()
	new_element.toggled.connect(update)
	new_element.rename(element_name)
	elements.append(new_element)
	add_child(new_element)

	# Atualizando posições
	update()
	return new_element

func add_leaf(element_name: String) -> Leaf:
	# Adicionando o novo element
	var new_element = leaf_path.instantiate()
	new_element.rename(element_name)
	elements.append(new_element)
	add_child(new_element)

	# Atualizando posições
	update()
	return new_element

func _on_seta_button_down() -> void:
	if open:
		open = false
		$Linha.visible = false
		for element in elements:
			element.visible = false
	else:
		open = true
		$Linha.visible = true
		for element in elements:
			element.visible = true
	emit_signal("toggled")
