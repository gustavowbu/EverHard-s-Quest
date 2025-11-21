extends Node2D
class_name Class

var nome := ""
var atributos := {}
var metodos := {}

func declarar_atributo(encapsulamento, tipo, nome_atributo: String, valor) -> void:
	atributos[nome_atributo] = {"encapsulamento": encapsulamento, "tipo": tipo, "valor": valor}

func alterar_atributo(nome_atributo: String, valor):
	if typeof(valor) != atributos[nome_atributo]["tipo"]:
		var erro = Erro.new()
		erro.message = "Incompatibilidade de tipo: não pôde converter " + unmap_tipo(typeof(valor)) + " para " + unmap_tipo(atributos[nome_atributo]["tipo"])
		erro.print_message()
		return erro
	atributos[nome_atributo]["valor"] = valor

func ler_atributo(nome_atributo):
	if not nome_atributo in atributos.keys():
		var erro = Erro.new()
		erro.message = nome_atributo + " não pode ser resolvido ou não é um campo"
		erro.print_message()
		return erro
	return atributos[nome_atributo]["valor"]

func alterar_metodo(encapsulamento, tipo, nome_metodo: String, parametros: Array, algoritmo: Callable) -> void:
	metodos[nome_metodo] = {"encapsulamento": encapsulamento, "tipo": tipo, "parametros": parametros, "algoritmo": algoritmo}

func chamar_metodo(nome_metodo: String, parametros: Array):
	return metodos[nome_metodo]["algoritmo"].call(parametros)

func unmap_tipo(tipo):
	if tipo == TYPE_INT:
		return "int"
	if tipo == TYPE_STRING:
		return "String"
	if tipo == TYPE_BOOL:
		return "boolean"

func get_classe() -> String:
	return "Class"
