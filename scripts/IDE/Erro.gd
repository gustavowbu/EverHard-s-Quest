extends Node2D
class_name Erro

var message: String
var nome := "Erro"

func get_message() -> String:
	return nome + ": " + message

func print_message() -> void:
	print(get_message())

func get_classe() -> String:
	return "Erro"
