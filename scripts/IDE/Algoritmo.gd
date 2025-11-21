extends Node2D
class_name Algoritmo

var expressoes := []

func copy() -> Algoritmo:
	var copia = Algoritmo.new()
	for i in range(len(expressoes)):
		copia.expressoes.append(expressoes[i].copy())
	return copia

func to_str() -> String:
	var resultado = "["
	var i = 0
	for expressao in expressoes:
		resultado += expressao.to_str()
		if i != len(expressoes) - 1:
			resultado += ", "
		i += 1
	resultado += "]"
	return resultado

func print_algoritmo() -> void:
	print(to_str())

func get_classe() -> String:
	return "Algoritmo"
