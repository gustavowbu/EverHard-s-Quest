extends JavaDataType
class_name ClassJDT

signal sout(message)

var encapsulamento: JavaDataType
var nome := StringJDT.new()
var atributos := {}
var metodos := {}

func _init(encapsulamento_in: JavaDataType = NullJDT.new(), nome_in := StringJDT.new(), atributos_in := {}, metodos_in := {}) -> void:
	classe = "Class"
	encapsulamento = encapsulamento_in
	nome = nome_in
	atributos = atributos_in
	metodos = metodos_in

func toString() -> JavaDataType:
	var result = ""
	if encapsulamento.classe != "null":
		result += encapsulamento.repr() + " "
	result += "class " + nome.value + " {" + "\n"
	for atributo_key in atributos.keys():
		var atributo = atributos[atributo_key]
		result += atributo.repr(1) + "\n"
	if len(atributos) != 0 and  len(metodos) != 0:
		result += "\n"
	var i := 0
	for metodo_key in metodos.keys():
		var metodo = metodos[metodo_key]
		if i != 0:
			result += "\n"
		result += metodo.repr(1) + "\n"
		i += 1
	result += "}"
	return StringJDT.new(result)

func declarar_atributo(encapsulamento_atributo: JavaDataType, tipo: StringJDT, nome_atributo: StringJDT, valor_padrao: JavaDataType):
	if nome_atributo in atributos.keys():
		return ExceptionJDT.new("", "Campo duplicado " + nome.repr() + "." + nome_atributo.repr())
	atributos[nome_atributo.repr()] = AttributeJDT.new(encapsulamento_atributo, tipo, nome_atributo, valor_padrao)

func alterar_atributo(nome_atributo: StringJDT, valor: JavaDataType):
	if not nome_atributo.repr() in atributos.keys():
		return ExceptionJDT.new("", nome_atributo.repr() + " não pode ser resolvido ou não é um campo")
	if valor.classe != atributos[nome_atributo.repr()].tipo.repr():
		return ExceptionJDT.new("", "Tipo incompatível: não é possível converter de " + valor.classe + " para " + atributos[nome_atributo.repr()].tipo.repr())
	atributos[nome_atributo.repr()].alterar_valor(valor)
	return NullJDT.new()

func ler_atributo(nome_atributo: StringJDT) -> JavaDataType:
	if not nome_atributo.repr() in atributos.keys():
		return ExceptionJDT.new("", nome_atributo.repr() + " não pode ser resolvido ou não é um campo")
	return atributos[nome_atributo.repr()].valor

func declarar_metodo(encapsulamento_metodo: JavaDataType, estatico: BooleanJDT, tipo: StringJDT, nome_metodo: StringJDT, parametros_tipos: ArrayJDT, parametros_nomes: ArrayJDT, algoritmo: AlgorithmJDT):
	var tipos_parametros = ""
	for i in range(parametros_tipos.length().value):
		if i != 0:
			tipos_parametros += ", "
		tipos_parametros += parametros_tipos.getElement(IntJDT.new(i)).repr()
	var metodo_key = nome_metodo.repr() + "(" + tipos_parametros + ")"
	if nome_metodo in metodos.keys():
		return ExceptionJDT.new("", "Método duplicado " + nome_metodo.repr() + "(" + tipos_parametros + ") no tipo " + nome.repr())
	metodos[metodo_key] = MethodJDT.new(encapsulamento_metodo, estatico, tipo, nome_metodo, parametros_tipos, parametros_nomes, algoritmo)
	metodos[metodo_key].sout.connect(println)

func chamar_metodo(nome_metodo: StringJDT, parametros: ArrayJDT, classes: ArrayJDT):
	# 1. Transformar array de parâmetros em array de tipos
	var parametros_tipos = ArrayJDT.new()
	var tipos_parametros = ""
	for i in range(parametros.length().value):
		parametros_tipos.append(StringJDT.new(parametros.getElement(IntJDT.new(i)).classe))
		if i != 0:
			tipos_parametros += ", "
		tipos_parametros += parametros_tipos.getElement(IntJDT.new(i)).repr()

	# 2. Conseguir a chave do método (nome + tipos dos parâmetros)
	var key = nome_metodo.repr() + "(" + tipos_parametros + ")"
	if not key in metodos.keys():
		return ExceptionJDT.new("", "O método " + nome_metodo.repr() + "(" + tipos_parametros + ") não é definido para o tipo " + nome.repr())

	# 3. Chamar o método
	var result = metodos[key].chamar(parametros, self, classes)

	# 4. Alterar atributos
	var escopo = result[1]
	result = result[0]
	for variable in escopo.keys():
		if variable.begins_with("this."):
			var resultado = alterar_atributo(StringJDT.new(variable.substr(5)), escopo[variable]["valor"])
			if resultado.classe == "Exception":
				return resultado
	return result

func instanciar(classes: ArrayJDT):
	var resultado = copy()
	for atributo_key in resultado.atributos.keys():
		var atributo = resultado.atributos[atributo_key]
		resultado.atributos[atributo_key] = atributo.instanciar(classes)
	return resultado

func copy() -> ClassJDT:
	var atributos_copy = {}
	for atributo_key in atributos.keys():
		var atributo = atributos[atributo_key]
		atributos_copy[atributo_key] = atributo.copy()
	return ClassJDT.new(encapsulamento, nome, atributos_copy, metodos)

func println(message: String) -> void:
	emit_signal("sout", message)
