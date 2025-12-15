extends JavaDataType
class_name AlgorithmJDT

var expressoes := ArrayJDT.new()

func _init(expressoes_in := ArrayJDT.new()) -> void:
	classe = "Algoritmo"
	expressoes = expressoes_in

func repr(identation: int = 0) -> String:
	var result = ""
	for i in range(expressoes.length().value):
		var expressao = expressoes.getElement(IntJDT.new(i))
		for j in range(identation):
			result += "    "
		result += expressao.repr() + ";"
		if i != expressoes.length().value - 1:
			result += "\n"
		i += 1
	return result

func toString() -> StringJDT:
	var result = "Algoritmo("
	for i in range(expressoes.length()):
		var expressao = expressoes.getElement(IntJDT.new(i))
		result += expressao.repr()
		if i != len(expressoes) - 1:
			result += ", "
		i += 1
	result += ")"
	return StringJDT.new(result)

func copy() -> AlgorithmJDT:
	var copia = AlgorithmJDT.new()
	for i in range(expressoes.length()):
		copia.expressoes.append(expressoes.getElement(IntJDT.new(i)).copy())
	return copia

func append(expressao: ExpressionJDT) -> void:
	expressoes.append(expressao)

func execute(escopo := {}) -> Array:
	# Computar expressões
	for i in range(expressoes.length().value):
		var expressao = expressoes.getElement(IntJDT.new(i))
		var resultado_expressao = computar_expressao(expressao, escopo)
		var resultado = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if resultado.classe == "Exception":
			return [resultado, escopo]
		if expressao.nome.equals(StringJDT.new("return")).value:
			return [resultado, escopo]
	return [NullJDT.new(), escopo]

func exec(escopo := {}) -> Array:
	return execute(escopo)

# Retorna um array com dois elementos: o retorno da expressão e o escopo
func computar_expressao(expressao: JavaDataType, escopo := {}) -> Array:
	var resultado = NullJDT.new()
	if expressao.classe != "Expression":
		resultado = expressao
		return [resultado, escopo]

	var resultado_expressao
	var par = expressao.parametros.value
	var valor1
	var valor2

	if expressao.nome.equals(StringJDT.new("declare")).value:
		if par[1].repr() in escopo.keys():
			resultado = ExceptionJDT.new("", "Variável local \"" + par[0].repr() + "\" duplicada")
			return [resultado, escopo]
		escopo[par[1].repr()] = {"tipo": par[0], "nome": par[1], "valor": NullJDT.new()}

	elif expressao.nome.equals(StringJDT.new("assign")).value:
		if not par[0].repr() in escopo.keys():
			if par[0].begins_with(StringJDT.new("this.")).value:
				resultado = ExceptionJDT.new("", par[0].substr(IntJDT.new(5)).repr() + " não pode ser resolvido ou não é um campo")
			else:
				resultado = ExceptionJDT.new("", par[0].repr() + " não pode ser resolvido a uma variável")
			return [resultado, escopo]
		resultado_expressao = computar_expressao(par[1], escopo)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		if escopo[par[0].repr()]["tipo"].repr() != valor1.classe:
			resultado = ExceptionJDT.new("", "Incompatibilidade de tipo: não pôde converter " + valor1.classe + " para " + escopo[par[0].repr()]["tipo"].repr())
			return [resultado, escopo]
		escopo[par[0].repr()]["valor"] = valor1

	elif expressao.nome.equals(StringJDT.new("declare and assign")).value:
		if par[1].repr() in escopo.keys():
			resultado = ExceptionJDT.new("", "Variável local \"" + par[0] + "\" duplicada")
			return [resultado, escopo]
		resultado_expressao = computar_expressao(par[2], escopo)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		if par[0].repr() != valor1.classe:
			resultado = ExceptionJDT.new("", "Incompatibilidade de tipo: não pôde converter " + par[0].repr() + " para " + valor1.classe)
			return [resultado, escopo]
		escopo[par[1].repr()] = {"tipo": par[0], "nome": par[1], "valor": valor1}

	elif expressao.nome.equals(StringJDT.new("addition")).value:
		resultado_expressao = computar_expressao(par[0], escopo)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		resultado_expressao = computar_expressao(par[1], escopo)
		valor2 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor2.classe == "Exception":
			resultado = valor2
			return [resultado, escopo]
		if not valor1.classe in ["int", "String"] or not valor2.classe in ["int", "String"]:
			resultado = ExceptionJDT.new("", "O operador + não é definido para o(s) tipo(s) de argumentos " + valor1.classe + ", " + valor2.classe)
			return [resultado, escopo]
		if valor1.classe == "String" or valor2.classe == "String":
			valor1 = valor1.toString()
			valor2 = valor2.toString()
		resultado = valor1.add(valor2)

	elif expressao.nome.equals(StringJDT.new("subtraction")).value:
		resultado_expressao = computar_expressao(par[0], escopo)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		resultado_expressao = computar_expressao(par[1], escopo)
		valor2 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor2.classe == "Exception":
			resultado = valor2
			return [resultado, escopo]
		if valor1.classe != valor2.classe or valor1.classe != "int":
			resultado = ExceptionJDT.new("", "O operador - não é definido para o(s) tipo(s) de argumentos " + valor1.classe + ", " + valor2.classe)
			return [resultado, escopo]
		resultado = valor1.subtract(valor2)

	elif expressao.nome.equals(StringJDT.new("multiplication")).value:
		resultado_expressao = computar_expressao(par[0], escopo)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		resultado_expressao = computar_expressao(par[1], escopo)
		valor2 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor2.classe == "Exception":
			resultado = valor2
			return [resultado, escopo]
		if valor1.classe != valor2.classe or valor1.classe != "int":
			resultado = ExceptionJDT.new("", "O operador * não é definido para o(s) tipo(s) de argumentos " + valor1.classe + ", " + valor2.classe)
			return [resultado, escopo]
		resultado = valor1.multiply(valor2)

	elif expressao.nome.equals(StringJDT.new("division")).value:
		resultado_expressao = computar_expressao(par[0], escopo)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		resultado_expressao = computar_expressao(par[1], escopo)
		valor2 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor2.classe == "Exception":
			resultado = valor2
			return [resultado, escopo]
		if valor1.classe != valor2.classe or valor1.classe != "int":
			resultado = ExceptionJDT.new("", "O operador / não é definido para o(s) tipo(s) de argumentos " + valor1.classe + ", " + valor2.classe)
			return [resultado, escopo]
		resultado = valor1.divide(valor2)

	elif expressao.nome.equals(StringJDT.new("equals")).value:
		resultado_expressao = computar_expressao(par[0], escopo)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		resultado_expressao = computar_expressao(par[1], escopo)
		valor2 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor2.classe == "Exception":
			resultado = valor2
			return [resultado, escopo]
		if valor1.classe != valor2.classe:
			resultado = ExceptionJDT.new("", "O operador == não é definido para o(s) tipo(s) de argumentos " + valor1.classe + ", " + valor2.classe)
			return [resultado, escopo]
		resultado = valor1.equals(valor2)

	elif expressao.nome.equals(StringJDT.new("different")).value:
		resultado_expressao = computar_expressao(par[0], escopo)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		resultado_expressao = computar_expressao(par[1], escopo)
		valor2 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor2.classe == "Exception":
			resultado = valor2
			return [resultado, escopo]
		if valor1.classe != valor2.classe:
			resultado = ExceptionJDT.new("", "O operador != não é definido para o(s) tipo(s) de argumentos " + valor1.classe + ", " + valor2.classe)
			return [resultado, escopo]
		resultado = valor1.different(valor2)

	elif expressao.nome.equals(StringJDT.new("greater than")).value:
		resultado_expressao = computar_expressao(par[0], escopo)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		resultado_expressao = computar_expressao(par[1], escopo)
		valor2 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor2.classe == "Exception":
			resultado = valor2
			return [resultado, escopo]
		if valor1.classe != valor2.classe or valor1.classe != "int":
			resultado = ExceptionJDT.new("", "O operador > não é definido para o(s) tipo(s) de argumentos " + valor1.classe + ", " + valor2.classe)
			return [resultado, escopo]
		resultado = valor1.greater_than(valor2)

	elif expressao.nome.equals(StringJDT.new("less than")).value:
		resultado_expressao = computar_expressao(par[0], escopo)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		resultado_expressao = computar_expressao(par[1], escopo)
		valor2 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor2.classe == "Exception":
			resultado = valor2
			return [resultado, escopo]
		if valor1.classe != valor2.classe or valor1.classe != "int":
			resultado = ExceptionJDT.new("", "O operador < não é definido para o(s) tipo(s) de argumentos " + valor1.classe + ", " + valor2.classe)
			return [resultado, escopo]
		resultado = valor1.less_than(valor2)

	elif expressao.nome.equals(StringJDT.new("greater than or equal")).value:
		resultado_expressao = computar_expressao(par[0], escopo)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		resultado_expressao = computar_expressao(par[1], escopo)
		valor2 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor2.classe == "Exception":
			resultado = valor2
			return [resultado, escopo]
		if valor1.classe != valor2.classe or valor1.classe != "int":
			resultado = ExceptionJDT.new("", "O operador >= não é definido para o(s) tipo(s) de argumentos " + valor1.classe + ", " + valor2.classe)
			return [resultado, escopo]
		resultado = valor1.greater_than_or_equal(valor2)

	elif expressao.nome.equals(StringJDT.new("less than or equal")).value:
		resultado_expressao = computar_expressao(par[0], escopo)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		resultado_expressao = computar_expressao(par[1], escopo)
		valor2 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor2.classe == "Exception":
			resultado = valor2
			return [resultado, escopo]
		if valor1.classe != valor2.classe or valor1.classe != "int":
			resultado = ExceptionJDT.new("", "O operador <= não é definido para o(s) tipo(s) de argumentos " + valor1.classe + ", " + valor2.classe)
			return [resultado, escopo]
		resultado = valor1.less_than_or_equal(valor2)

	elif expressao.nome.equals(StringJDT.new("read")).value:
		if not par[0].repr() in escopo.keys():
			resultado = ExceptionJDT.new("", par[0].repr() + " não pode ser resolvido a uma variável")
			return [resultado, escopo]
		resultado = escopo[par[0].repr()]["valor"]

	elif expressao.nome.equals(StringJDT.new("value")).value:
		resultado = par[0]

	elif expressao.nome.equals(StringJDT.new("return")).value:
		resultado_expressao = computar_expressao(par[0], escopo)
		resultado = resultado_expressao[0]
		escopo = resultado_expressao[1]
	return [resultado, escopo]
