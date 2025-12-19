extends CanvasLayer

@onready var editor = $"CodeArea/CodeEdit"
@onready var dropdown = $Dropdown
@onready var terminal = $Terminal
var compiler = Compiler.new()
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
	editor.text = get_codigo(index)
	atualizar_codigo()

func atualizar_codigo():
	var code: String = editor.text
	var classe = compiler.parse_code(code)

	if code == "":
		if not global.tabs[code_index] in ["Main", "Objeto vazio"]:
			global.objetos.erase(global.tabs[code_index])
		global.tabs[code_index] = "Objeto vazio"
		$Objeto/Sprite.texture = null
		dropdown.clear()
		return
	if classe.classe != "Exception":
		var nome = classe.nome.repr()
		if not nome in global.objetos.keys():
			if nome == "Pedra":
				global.objetos[nome] = Pedra.new()
			elif nome == "Slime":
				global.objetos[nome] = Slime.new()
			else:
				if not global.tabs[code_index] in ["Main", "Objeto vazio"]:
					global.objetos.erase(global.tabs[code_index])
				global.tabs[code_index] = "Objeto vazio"
				$Objeto/Sprite.texture = null
				dropdown.clear()
				return
		global.tabs[code_index] = nome
		global.atualizar_objetos_selecionados()
		set_codigo(code_index, editor.text, nome)
		var objeto = global.objetos[nome]
		$Objeto/Sprite.texture = load(objeto.sprites["64x64_front"])
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
	var classes = get_classes()
	var classe = classes.getElement(IntJDT.new(code_index + 2))
	var nome = classe.nome.repr()

	var objeto = global.objetos[nome]
	objeto.metodos = []
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
			var resultado = classe.chamar_metodo(StringJDT.new(metodo), parametros, classes)
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
			objeto.metodos.append(metodo)
		i += 1

func _on_test_button_button_down() -> void: # Rodar a main
	terminal.limpar()

	var classes = get_classes()
	var classe = classes.getElement(IntJDT.new(2))
	var objetos_str = ""
	for i in range(len(global.objetos)):
		if i != 0:
			objetos_str += ", "
		var key = global.objetos.keys()[i]
		objetos_str += global.objetos[key].nome + "(" + str(global.objetos[key].metodos) + ")"
	print("Objetos: ", objetos_str)
	print("Objetos selecionados: ", global.objetos_selecionados)

	if classe.classe != "Exception":
		classe.sout.connect(terminal.adicionar_linha)
		for metodo_key in classe.metodos.keys():
			var metodo = classe.metodos[metodo_key]
			if metodo.estatico.value and metodo.tipo.repr() == "void" and metodo.nome.repr() == "main":
				classe.chamar_metodo(StringJDT.new("main"), ArrayJDT.new(), classes)
			else:
				terminal.adicionar_linha("Erro de Sintaxe: faltando public static void main()")
	else:
		terminal.adicionar_linha(classe.get_message())

func get_classes() -> ArrayJDT:
	# classes[0] = System
	# classes[1] = Out
	# classes[2] = Main
	var code: String
	var classe
	var classes = get_system_out_classes()
	for i in range(5):
		code = get_codigo(i)
		classe = compiler.parse_code(code)
		if classe.classe != "Exception":
			classes.append(classe)
	return classes

func get_system_out_classes() -> ArrayJDT:
	var classes = []
	var code = """public class System {
	Out out = new Out();
}
"""
	var classe = compiler.parse_code(code)
	classes.append(classe)

	code = """public class Out {
	String println(String x) {
		return x;
	}

	int println(int x) {
		return x;
	}
}
"""
	classe = compiler.parse_code(code)
	classes.append(classe)
	return ArrayJDT.new(classes)

func get_codigo(i: int) -> String:
	var codigo = ""
	if i != 0:
		var nome_objeto = global.tabs[i]
		if nome_objeto != "Objeto vazio":
			codigo = global.objetos[nome_objeto].codigo
	else:
		codigo = global.codigo_main
	return codigo

func set_codigo(i: int, codigo: String, nome_objeto = null) -> void:
	if nome_objeto == null:
		if i != 0:
			nome_objeto = global.tabs[i]
			if nome_objeto != "Objeto vazio":
				global.objetos[nome_objeto].codigo = codigo
		else:
			global.codigo_main = codigo
	else:
		if nome_objeto == "Main":
			global.codigo_main = codigo
		else:
			global.objetos[nome_objeto].codigo = codigo

# Mudar aba

func update_tabs() -> void:
	for i in range(5):
		get_node("CodeArea/Tab" + str(i)).update_text(global.tabs[i])

func change_tab(tab: int) -> void:
	for i in range(5):
		get_node("CodeArea/Tab" + str(i)).close()
	get_node("CodeArea/Tab" + str(tab)).open()
	# Alterar código
	dropdown.clear()
	$Objeto/Sprite.texture = null
	alterar_codigo(tab)
	dropdown.update()

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
