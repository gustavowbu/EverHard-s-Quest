extends Node2D
class_name Expressao

var nome: String
var parametros: Array

func get_classe() -> String:
	return "Expressao"

func to_str() -> String:
	var resultado = "[" + nome + ": "
	var i = 0
	for parametro in parametros:
		if typeof(parametro) == 24:
			resultado += parametro.to_str()
		else:
			resultado += str(parametro)
		if i != len(parametros) - 1:
			resultado += ", "
		i += 1
	resultado += "]"
	return resultado

func print_expressao() -> void:
	print(to_str())

func copy() -> Expressao:
	var copia = Expressao.new()
	copia.nome = nome
	for i in range(len(parametros)):
		if typeof(parametros[i]) == 24:
			copia.parametros.append(parametros[i].copy())
		else:
			copia.parametros.append(parametros[i])
	return copia
