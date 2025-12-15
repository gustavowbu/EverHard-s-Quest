extends CanvasLayer

@onready var editor = $"Text Area/CodeEdit"
@onready var dropdown = $Classe
var compiler = Compiler.new()
var objeto
var testes = {}
var testes_dropdown = {}

var code_index = 0

func _ready() -> void:
	editor.grab_focus()
	update_tabs()
	change_tab(1)
	alterar_codigo(1)

func alterar_codigo(index: int) -> void:
	code_index = index
	editor.text = global.tabs[code_index]["codigo"]
	atualizar_codigo()

func atualizar_codigo():
	global.tabs[code_index]["codigo"] = editor.text
	var code: String = editor.text
	var classe = compiler.parse_code(code)

	if classe.classe != "Exception":
		global.tabs[code_index]["codigo"] = editor.text
		global.tabs[code_index]["nome"] = classe.nome.repr()
		if classe.nome.repr() == "Pedra":
			objeto = Pedra.new()
		elif classe.nome.repr() == "Zumbi":
			objeto = Zumbi.new()
		$SpriteObjeto.texture = load(objeto.sprites["32x32_front"])
		testes = objeto.testes
		dropdown.clear()
		for teste in testes.keys():
			testes_dropdown[teste] = dropdown.add_dropdown(teste)
			for i in range(len(testes[teste])):
				testes_dropdown[teste].add_leaf("Caso de teste " + str(i + 1))
		dropdown.update()

func _on_code_edit_text_changed() -> void:
	atualizar_codigo()

func _on_run_button_button_down() -> void:
	var code: String = editor.text
	var classe := compiler.parse_code(code)
	global.objetos[code_index].metodos = []
	if classe.classe == "Exception":
		for teste in testes.keys():
			for i in range(len(testes[teste])):
				testes_dropdown[teste].elements[i].alterar_icone("res://sprites/errado.png")
		return
	var i = 0
	for metodo in testes.keys():
		var metodo_correto = true
		var j = 0
		for teste in testes[metodo]:
			var parametros := ArrayJDT.new()
			for parametro_key in teste.keys():
				var parametro = teste[parametro_key]
				var valor
				if typeof(parametro) == TYPE_INT:
					valor = IntJDT.new(parametro)
				if typeof(parametro) == TYPE_STRING:
					valor = StringJDT.new(parametro)
				if typeof(parametro) == TYPE_BOOL:
					valor = BooleanJDT.new(parametro)

				if parametro_key.begins_with("this."):
					classe.alterar_atributo(StringJDT.new(parametro_key.substr(5)), valor)
				elif parametro_key == "esperado":
					pass
				else:
					parametros.append(valor)
			var resultado = classe.chamar_metodo(StringJDT.new(metodo), parametros)
			var correto = false
			if resultado.classe != "Exception" and resultado.classe != "null":
				if resultado.value == teste["esperado"]:
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

func _on_test_button_button_down() -> void:
	var code: String = global.tabs[0]["codigo"]
	var classe := compiler.parse_code(code)
	if classe.classe != "Exception":
		for metodo_key in classe.metodos.keys():
			var metodo = classe.metodos[metodo_key]
			if metodo.estatico.value and metodo.nome.repr() == "main":
				# Completar isso
				pass
# Mudar aba

func update_tabs() -> void:
	for i in range(5):
		get_node("Text Area/Tab" + str(i)).update_text(global.tabs[i]["nome"])

func change_tab(tab: int) -> void:
	for i in range(5):
		get_node("Text Area/Tab" + str(i)).close()
	get_node("Text Area/Tab" + str(tab)).open()
	# Alterar código
	dropdown.clear()
	$SpriteObjeto.texture = null
	alterar_codigo(tab)

func _on_tab_0_button_down() -> void:
	change_tab(0)
func _on_tab_1_button_down() -> void:
	change_tab(1)
func _on_tab_2_button_down() -> void:
	change_tab(2)
func _on_tab_3_button_down() -> void:
	change_tab(3)
func _on_tab_4_button_down() -> void:
	change_tab(4)

# Sair

func _on_back_button_button_down() -> void:
	voltar()

func _input(_event) -> void:
	if Input.is_action_just_pressed("pause"):
		await get_tree().create_timer(0.05).timeout
		voltar()

var previous_scene: Node = null
func voltar() -> void:
	get_tree().current_scene.queue_free()
	if previous_scene.get_parent() == null:
		get_tree().get_root().add_child(previous_scene)
	get_tree().current_scene = previous_scene
