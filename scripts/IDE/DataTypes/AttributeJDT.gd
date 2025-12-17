extends JavaDataType
class_name AttributeJDT

var encapsulamento: JavaDataType
var tipo := StringJDT.new()
var nome := StringJDT.new()
var valor_padrao: JavaDataType
var valor: JavaDataType

func _init(encapsulamento_in: JavaDataType = NullJDT.new(), tipo_in := StringJDT.new(), nome_in := StringJDT.new(), valor_padrao_in: JavaDataType = NullJDT.new()) -> void:
	classe = "Attribute"
	encapsulamento = encapsulamento_in
	tipo = tipo_in
	nome = nome_in
	valor_padrao = valor_padrao_in

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
	if encapsulamento.classe != "null":
		result += encapsulamento.repr() + " "
	result += tipo.repr() + " "
	result += nome.repr()
	if valor_padrao.classe != "null":
		var valor_padrao_str
		if valor_padrao.classe == "Algorithm":
			valor_padrao_str = valor_padrao.expressoes.getElement(IntJDT.new(0)).parametros.getElement(IntJDT.new(0)).repr()
		else:
			valor_padrao_str = valor_padrao.repr()
		result += " = " + valor_padrao_str
	result += ";"
	return StringJDT.new(result)

func alterar_valor(valor_in: JavaDataType) -> void:
	var tipo_valor
	if valor_in.classe == "Class":
		tipo_valor = valor_in.nome.repr()
	else:
		tipo_valor = valor_in.classe
	if tipo_valor != tipo.repr() and tipo_valor != "null":
		return ExceptionJDT.new("Tipo incompatível", "não é possível converter de " + tipo_valor + " para " + tipo.repr())
	valor = valor_in

func instanciar(classes: ArrayJDT):
	var resultado = copy()
	resultado.alterar_valor(resultado.valor_padrao.exec({}, null, classes)[0])
	return resultado

func copy() -> AttributeJDT:
	var valor_padrao_copy
	if valor_padrao.classe == "Class":
		valor_padrao_copy = valor_padrao.copy()
	else:
		valor_padrao_copy = valor_padrao
	return AttributeJDT.new(encapsulamento, tipo, nome, valor_padrao_copy)
