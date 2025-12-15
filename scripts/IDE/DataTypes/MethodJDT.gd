extends JavaDataType
class_name MethodJDT

var encapsulamento: JavaDataType
var estatico := BooleanJDT.new(false)
var tipo := StringJDT.new()
var nome := StringJDT.new()
var parametros_tipos := ArrayJDT.new()
var parametros_nomes := ArrayJDT.new()
var algoritmo: AlgorithmJDT

func _init(encapsulamento_in := NullJDT.new(), estatico_in := BooleanJDT.new(false), tipo_in := StringJDT.new(), nome_in := StringJDT.new(), parametros_tipos_in := ArrayJDT.new(), parametros_nomes_in := ArrayJDT.new(), algoritmo_in := AlgorithmJDT.new()) -> void:
	classe = "Method"
	encapsulamento = encapsulamento_in
	estatico = estatico_in
	tipo = tipo_in
	nome = nome_in
	parametros_tipos = parametros_tipos_in
	parametros_nomes = parametros_nomes_in
	algoritmo = algoritmo_in

# Esse método é reimplementado aqui apenas para adicionar o parâmetro da identação
func repr(identation: int = 0) -> String:
	var result = toString(identation)
	if result.classe == "Exception":
		return result.get_message()
	return result.value

func toString(identation: int = 0) -> JavaDataType:
	var result = ""
	for i in range(identation):
		result += "    "
	if encapsulamento.different(NullJDT.new()):
		result += encapsulamento.repr() + " "
	result += tipo.repr() + " "
	result += nome.repr() + "("
	for i in range(parametros_tipos.length().value):
		result += parametros_tipos.getElement(IntJDT.new(i)).repr() + " "
		result += parametros_nomes.getElement(IntJDT.new(i)).repr()
		if i != parametros_tipos.length().value - 1:
			result += ", "
	result += ") {\n"
	result += algoritmo.repr(identation + 1)
	result += "\n"
	for i in range(identation):
		result += "    "
	result += "}"
	return StringJDT.new(result)

func chamar(parametros: ArrayJDT, atributos: Dictionary):
	# Definir escopo
	var escopo = {}

	# Adicionar os parâmetros ao escopo
	for i in range(parametros_nomes.length().value):
		var nome_parametro = parametros_nomes.getElement(IntJDT.new(i))
		var tipo_parametro = parametros_tipos.getElement(IntJDT.new(i))
		escopo[nome_parametro.repr()] = {"tipo": tipo_parametro, "nome": nome_parametro, "valor": parametros.getElement(IntJDT.new(i))}

	# Adicionar os atributos ao escopo
	for key in atributos.keys():
		var atributo = atributos[key]
		var nome_atributo = StringJDT.new("this.").add(atributo.nome)
		var tipo_atributo = atributo.tipo
		escopo[nome_atributo.repr()] = {"tipo": tipo_atributo, "nome": nome_atributo, "valor": atributo.valor}

	# Executar
	var result = algoritmo.exec(escopo)
	var resultado = result[0]
	escopo = result[1]
	return [resultado, escopo]
