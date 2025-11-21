extends CanvasLayer

@onready var editor = $"Text Area/CodeEdit"
@onready var dropdown = $Classe
var compiler = Compiler.new()
var classe
var objeto
var metodos = {}
var metodos_dropdown = {}

func _ready() -> void:
	editor.grab_focus()

var code_index = 0
func alterar_codigo(index: int) -> void:
	code_index = index
	editor.text = global.codigos[code_index]

func _on_run_button_button_down() -> void:
	var code: String = editor.text
	classe = compiler.parse_code(code)
	global.objetos[code_index]["metodos"] = []
	if not is_error(classe):
		var i = 0
		for metodo in metodos.keys():
			var metodo_correto = true
			var j = 0
			for teste in metodos[metodo]:
				var parametros := []
				for parametro in teste.keys():
					if parametro.begins_with("this."):
						classe.alterar_atributo(parametro.substr(5), teste[parametro])
					elif parametro == "esperado":
						pass
					else:
						parametros.append(teste[parametro])
				var resultado = classe.chamar_metodo(metodo, parametros)
				var correto = false
				if not is_error(resultado):
					if resultado == teste["esperado"]:
						correto = true
				if correto:
					dropdown.elements[i].elements[j].alterar_icone("res://sprites/certo.png")
				else:
					metodo_correto = false
					dropdown.elements[i].elements[j].alterar_icone("res://sprites/errado.png")
				j += 1
			if metodo_correto:
				global.objetos[code_index]["metodos"].append(metodo)
			i += 1
	else:
		for metodo in metodos.keys():
			for i in range(len(metodos[metodo])):
				metodos_dropdown[metodo].elements[i].alterar_icone("res://sprites/errado.png")

func is_error(valor) -> bool:
	if typeof(valor) != 24:
		return false
	return valor.get_classe() == "Erro"

func _on_code_edit_text_changed() -> void:
	update()

func update():
	global.codigos[code_index] = editor.text
	var code: String = editor.text
	classe = compiler.parse_code(code)

	if classe.get_classe() == "Class":
		if global.objetos[code_index]["nome"] != classe.nome:
			global.objetos[code_index]["nome"] = classe.nome
		if classe.nome == "Pedra":
			$Sprite2D.texture = load("res://sprites/Objetos/pedra-frente.png")
			objeto = Pedra.new()
		elif classe.nome == "Zumbi":
			$Sprite2D.texture = load("res://sprites/Objetos/zumbi-costas-2.png")
			objeto = Zumbi.new()
		metodos = objeto.metodos
		dropdown.clear()
		for metodo in metodos.keys():
			metodos_dropdown[metodo] = dropdown.add_dropdown(metodo)
			for i in range(len(metodos[metodo])):
				metodos_dropdown[metodo].add_leaf("Caso de teste " + str(i + 1))
		dropdown.update()

func _on_back_button_button_down() -> void:
	voltar()

func _input(event) -> void:
	if Input.is_action_just_pressed("pause"):
		await get_tree().create_timer(0.05).timeout
		voltar()

var previous_scene: Node = null
func voltar() -> void:
	get_tree().current_scene.queue_free()
	if previous_scene.get_parent() == null:
		get_tree().get_root().add_child(previous_scene)
	get_tree().current_scene = previous_scene
