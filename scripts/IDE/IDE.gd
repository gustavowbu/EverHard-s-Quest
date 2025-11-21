extends CanvasLayer

@onready var editor = $"Text Area/CodeEdit"
@onready var dropdown = $Classe
var compiler = Compiler.new()
var classe
var objeto
var metodos

func _ready() -> void:
	editor.grab_focus()

func _on_run_button_button_down() -> void:
	var code: String = editor.text
	classe = compiler.parse_code(code)
	print("")
	print("")
	print("")
	if not is_error(classe):
		var i = 0
		for metodo in metodos.keys():
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
				print("Resultado:")
				print(resultado)
				var correto = false
				if not is_error(resultado):
					if resultado == teste["esperado"]:
						correto = true
				if correto:
					dropdown.elements[i].elements[j].alterar_icone("res://sprites/certo.png")
				else:
					dropdown.elements[i].elements[j].alterar_icone("res://sprites/errado.png")
				j += 1
			i += 1

func is_error(valor) -> bool:
	if typeof(valor) != 24:
		return false
	return valor.get_classe() == "Erro"

func _on_code_edit_text_changed() -> void:
	var code: String = editor.text
	classe = compiler.parse_code(code)

	if classe.get_classe() == "Class":
		if classe.nome == "Pedra":
			$Sprite2D.texture = load("res://sprites/pedra-frente.png")
			objeto = Pedra.new()
		elif classe.nome == "Zumbi":
			$Sprite2D.texture = load("res://sprites/zumbi-frente.png")
			objeto = Zumbi.new()
		metodos = objeto.metodos
		dropdown.clear()
		for metodo in metodos.keys():
			var metodo_dropdown = dropdown.add_dropdown(metodo)
			for i in range(len(metodos[metodo])):
				metodo_dropdown.add_leaf("Caso de teste " + str(i + 1))
		dropdown.update()
