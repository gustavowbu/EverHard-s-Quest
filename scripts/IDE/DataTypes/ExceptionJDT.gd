extends JavaDataType
class_name ExceptionJDT

var message: String
var nome: String

func _init(nome_in: String = "Exception", message_in: String = "") -> void:
	classe = "Exception"
	nome = nome_in
	message = message_in

func toString() -> StringJDT:
	return StringJDT.new(get_message())

func get_message() -> String:
	var result = nome
	if nome != "" && message != "":
		result += ": "
	result += message
	return result

func print_message() -> void:
	print(get_message())
