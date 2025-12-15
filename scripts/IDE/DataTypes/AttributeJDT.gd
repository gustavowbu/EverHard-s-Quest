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
	alterar_valor(valor_padrao)

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
		result += " = " + valor_padrao.repr()
	result += ";"
	return StringJDT.new(result)

func alterar_valor(valor_in: JavaDataType) -> void:
	if valor_in.classe != tipo.repr() and valor_in.classe != "null":
		return ExceptionJDT.new("Tipo incompatível", "não é possível converter de " + valor_in.classe + " para " + tipo.repr())
	valor = valor_in
