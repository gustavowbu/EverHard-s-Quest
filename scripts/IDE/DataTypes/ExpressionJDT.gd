extends JavaDataType
class_name ExpressionJDT

var nome := StringJDT.new()
var parametros := ArrayJDT.new()

func _init(nome_in := StringJDT.new(), parametros_in := ArrayJDT.new()) -> void:
	classe = "Expression"
	nome = nome_in
	parametros = parametros_in

func repr() -> String:
	var result = ""
	if nome.repr() == "declare":
		result += parametros.getElement(IntJDT.new(0)).repr() # tipo da variável
		result += " "
		result += parametros.getElement(IntJDT.new(1)).repr() # nome da variável
	elif nome.repr() == "assign":
		result += parametros.getElement(IntJDT.new(0)).repr() # nome da variável
		result += " = "
		result += parametros.getElement(IntJDT.new(1)).repr() # valor da variável
	elif nome.repr() == "assign attribute":
		result += parametros.getElement(IntJDT.new(0)).repr() # objeto
		result += "."
		result += parametros.getElement(IntJDT.new(1)).repr() # atributo
		result += " = "
		result += parametros.getElement(IntJDT.new(2)).repr() # valor do atributo
	elif nome.repr() == "declare and assign":
		result += parametros.getElement(IntJDT.new(0)).repr() # tipo da variável
		result += " "
		result += parametros.getElement(IntJDT.new(1)).repr() # nome da variável
		result += " = "
		result += parametros.getElement(IntJDT.new(2)).repr() # valor da variável
	elif nome.repr() == "read":
		result += parametros.getElement(IntJDT.new(0)).repr() # nome da variável
	elif nome.repr() == "read attribute":
		result += parametros.getElement(IntJDT.new(0)).repr() # objeto
		result += "."
		result += parametros.getElement(IntJDT.new(1)).repr() # nome do atributo
	elif nome.repr() == "call method":
		result += parametros.getElement(IntJDT.new(0)).repr() # objeto
		result += "."
		result += parametros.getElement(IntJDT.new(1)).repr() # nome do método
		result += "("
		for i in range(parametros.getElement(IntJDT.new(2)).length().value): # parâmetros
			if i != 0:
				result += ", "
			result += parametros.getElement(IntJDT.new(2)).getElement(IntJDT.new(i)).repr()
		result += ")"
	elif nome.repr() == "new":
		result += "new "
		result += parametros.getElement(IntJDT.new(0)).repr() # nome do objeto
		result += "("
		for i in range(parametros.getElement(IntJDT.new(1)).length().value): # parâmetros
			if i != 0:
				result += ", "
			result += parametros.getElement(IntJDT.new(1)).getElement(IntJDT.new(i)).repr()
		result += ")"
	elif nome.repr() == "addition":
		result += parametros.getElement(IntJDT.new(0)).repr() # primeiro valor
		result += " + "
		result += parametros.getElement(IntJDT.new(1)).repr() # segundo valor
	elif nome.repr() == "subtraction":
		result += parametros.getElement(IntJDT.new(0)).repr() # primeiro valor
		result += " - "
		result += parametros.getElement(IntJDT.new(1)).repr() # segundo valor
	elif nome.repr() == "multiplication":
		result += parametros.getElement(IntJDT.new(0)).repr() # primeiro valor
		result += " * "
		result += parametros.getElement(IntJDT.new(1)).repr() # segundo valor
	elif nome.repr() == "division":
		result += parametros.getElement(IntJDT.new(0)).repr() # primeiro valor
		result += " / "
		result += parametros.getElement(IntJDT.new(1)).repr() # segundo valor
	elif nome.repr() == "equals":
		result += parametros.getElement(IntJDT.new(0)).repr() # primeiro valor
		result += " == "
		result += parametros.getElement(IntJDT.new(1)).repr() # segundo valor
	elif nome.repr() == "not onquals":
		result += parametros.getElement(IntJDT.new(0)).repr() # primeiro valor
		result += " != "
		result += parametros.getElement(IntJDT.new(1)).repr() # segundo valor
	elif nome.repr() == "greater than":
		result += parametros.getElement(IntJDT.new(0)).repr() # primeiro valor
		result += " > "
		result += parametros.getElement(IntJDT.new(1)).repr() # segundo valor
	elif nome.repr() == "less than":
		result += parametros.getElement(IntJDT.new(0)).repr() # primeiro valor
		result += " < "
		result += parametros.getElement(IntJDT.new(1)).repr() # segundo valor
	elif nome.repr() == "greater than or equal":
		result += parametros.getElement(IntJDT.new(0)).repr() # primeiro valor
		result += " >= "
		result += parametros.getElement(IntJDT.new(1)).repr() # segundo valor
	elif nome.repr() == "less than equal":
		result += parametros.getElement(IntJDT.new(0)).repr() # primeiro valor
		result += " <= "
		result += parametros.getElement(IntJDT.new(1)).repr() # segundo valor
	elif nome.repr() == "value":
		var value = parametros.getElement(IntJDT.new(0))
		if value.classe == "String":
			result += "\""
		result += value.repr()
		if value.classe == "String":
			result += "\""
	elif nome.repr() == "return":
		result += "return "
		result += parametros.getElement(IntJDT.new(0)).repr()
	return result

func toString() -> StringJDT:
	var result = "Expression(" + nome.repr() + ": "
	var i = 0
	for parametro in parametros.value:
		result += parametro.toString().value
		if i != parametros.length().value - 1:
			result += ", "
		i += 1
	result += ")"
	return StringJDT.new(result)

func copy() -> ExpressionJDT:
	var copia = ExpressionJDT.new(nome, parametros.copy())
	return copia
