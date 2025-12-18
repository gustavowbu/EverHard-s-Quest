extends JavaDataType
class_name AlgorithmJDT

signal sout(message)

var expressoes := ArrayJDT.new()

func _init(expressoes_in := ArrayJDT.new()) -> void:
	classe = "Algorithm"
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

func execute(escopo: Dictionary, this: ClassJDT, classes: ArrayJDT) -> Array:
	# Computar expressões
	for i in range(expressoes.length().value):
		var expressao = expressoes.getElement(IntJDT.new(i))
		var resultado_expressao = computar_expressao(expressao, escopo, this, classes)
		var resultado = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if resultado.classe == "Exception":
			return [resultado, escopo]
		if expressao.nome.equals(StringJDT.new("return")).value:
			return [resultado, escopo]
	return [NullJDT.new(), escopo]

func exec(escopo: Dictionary, this: ClassJDT, classes: ArrayJDT) -> Array:
	return execute(escopo, this, classes)

# Retorna um array com dois elementos: o retorno da expressão e o escopo
func computar_expressao(expressao: JavaDataType, escopo: Dictionary, this: ClassJDT, classes: ArrayJDT) -> Array:
	var resultado = NullJDT.new()
	if expressao.classe != "Expression":
		resultado = expressao
		return [resultado, escopo]

	var resultado_expressao
	var par = expressao.parametros.value
	var valor1
	var valor2

	if expressao.nome.equals(StringJDT.new("value")).value:
		resultado = par[0]

	elif expressao.nome.equals(StringJDT.new("declare")).value:
		if par[1].repr() in escopo.keys():
			resultado = ExceptionJDT.new("", "Variável local \"" + par[0].repr() + "\" duplicada")
			return [resultado, escopo]
		escopo[par[1].repr()] = {"tipo": par[0], "nome": par[1], "valor": NullJDT.new()}

	elif expressao.nome.equals(StringJDT.new("assign")).value:
		if not par[0].repr() in escopo.keys():
			resultado = ExceptionJDT.new("", par[0].repr() + " não pode ser resolvido a uma variável")
			return [resultado, escopo]
		resultado_expressao = computar_expressao(par[1], escopo, this, classes)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		var tipo_valor = StringJDT.new(valor1.classe)
		if valor1.classe == "Class":
			tipo_valor = valor1.nome
		if escopo[par[0].repr()]["tipo"].different(tipo_valor).value:
			resultado = ExceptionJDT.new("", "Tipo incompatível: não é possível converter de " + tipo_valor.repr() + " para " + escopo[par[0].repr()]["tipo"].repr())
			return [resultado, escopo]
		escopo[par[0].repr()]["valor"] = valor1

	elif expressao.nome.equals(StringJDT.new("assign attribute")).value:
		resultado_expressao = self.computar_expressao(par[0], escopo, this, classes)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		if valor1.classe != "Class":
			resultado = ExceptionJDT.new("", par[0].repr() + " não pode ser resolvido a uma classe")
			return [resultado, escopo]
		if not par[1].repr() in valor1.atributos.keys():
			resultado = ExceptionJDT.new("", par[1].repr() + " não pode ser resolvido ou não é um campo")
			return [resultado, escopo]
		resultado_expressao = self.computar_expressao(par[2], escopo, this, classes)
		valor2 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		valor1.alterar_atributo(par[1], valor2)

	elif expressao.nome.equals(StringJDT.new("declare and assign")).value:
		if par[1].repr() in escopo.keys():
			resultado = ExceptionJDT.new("", "Variável local \"" + par[0] + "\" duplicada")
			return [resultado, escopo]
		resultado_expressao = computar_expressao(par[2], escopo, this, classes)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		var tipo_valor = StringJDT.new(valor1.classe)
		if valor1.classe == "Class":
			tipo_valor = valor1.nome
		if par[0].different(tipo_valor).value:
			resultado = ExceptionJDT.new("", "Tipo incompatível: não é possível converter de " + tipo_valor.repr() + " para " + par[0].repr())
			return [resultado, escopo]
		escopo[par[1].repr()] = {"tipo": par[0], "nome": par[1], "valor": valor1}

	elif expressao.nome.equals(StringJDT.new("read")).value:
		if not par[0].repr() in escopo.keys() and par[0].repr() != "this":
			resultado = ExceptionJDT.new("", par[0].repr() + " não pode ser resolvido a uma variável")
			return [resultado, escopo]
		if par[0].repr() == "this":
			resultado = this
		else:
			resultado = escopo[par[0].repr()]["valor"]

	elif expressao.nome.equals(StringJDT.new("read attribute")).value:
		resultado_expressao = computar_expressao(par[0], escopo, this, classes)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
		if valor1.classe != "Class":
			resultado = ExceptionJDT.new(valor1.repr() + " não pode ser resolvido a uma classe")
		if not par[1].repr() in valor1.atributos.keys():
			resultado = ExceptionJDT.new(par[1].repr() + " não pode ser resolvido ou não é um campo")
		#print(valor1.repr())
		#print(valor1.atributos["out"].valor_padrao.exec({}, valor1, classes)[0].repr())
		#print(valor1.atributos["out"].valor)
		#print(par[1].repr())
		resultado = valor1.ler_atributo(par[1])
		#print(resultado.repr())

	elif expressao.nome.equals(StringJDT.new("call method")).value:
		resultado_expressao = computar_expressao(par[0], escopo, this, classes)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		if valor1.classe != "Class":
			resultado = ExceptionJDT.new("", valor1.repr() + " não pode ser resolvido a uma classe")
			return [resultado, escopo]
		var tipos_parametros = ""
		var parametros = ArrayJDT.new([])
		for i in range(par[2].length().value):
			resultado_expressao = computar_expressao(par[2].getElement(IntJDT.new(i)), escopo, this, classes)
			valor2 = resultado_expressao[0]
			escopo = resultado_expressao[1]
			if valor2.classe == "Exception":
				return [valor2, escopo]
			parametros.append(valor2)
			if i != 0:
				tipos_parametros += ", "
			if valor2.classe == "Class":
				tipos_parametros += valor2.nome.repr()
			else:
				tipos_parametros += valor2.classe

		var metodo_key = par[1].repr() + "(" + tipos_parametros + ")"
		if not metodo_key in valor1.metodos.keys():
			resultado = ExceptionJDT.new("O método " + par[1].repr() + "(" + tipos_parametros + ") não é definido para o tipo " + valor1.nome.repr())
			return [resultado, escopo]
		valor1.sout.connect(println)
		resultado = valor1.chamar_metodo(par[1], parametros, classes)
		if par[0].repr() == "System.out":
			emit_signal("sout", valor2.repr())

	elif expressao.nome.equals(StringJDT.new("new")).value:
		for i in range(classes.length().value):
			var classe_in = classes.getElement(IntJDT.new(i))
			if par[0].equals(classe_in.nome).value:
				resultado = classe_in.instanciar(classes)
				break

	elif expressao.nome.equals(StringJDT.new("addition")).value:
		resultado_expressao = computar_expressao(par[0], escopo, this, classes)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		resultado_expressao = computar_expressao(par[1], escopo, this, classes)
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
		resultado_expressao = computar_expressao(par[0], escopo, this, classes)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		resultado_expressao = computar_expressao(par[1], escopo, this, classes)
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
		resultado_expressao = computar_expressao(par[0], escopo, this, classes)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		resultado_expressao = computar_expressao(par[1], escopo, this, classes)
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
		resultado_expressao = computar_expressao(par[0], escopo, this, classes)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		resultado_expressao = computar_expressao(par[1], escopo, this, classes)
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
		resultado_expressao = computar_expressao(par[0], escopo, this, classes)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		resultado_expressao = computar_expressao(par[1], escopo, this, classes)
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
		resultado_expressao = computar_expressao(par[0], escopo, this, classes)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		resultado_expressao = computar_expressao(par[1], escopo, this, classes)
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
		resultado_expressao = computar_expressao(par[0], escopo, this, classes)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		resultado_expressao = computar_expressao(par[1], escopo, this, classes)
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
		resultado_expressao = computar_expressao(par[0], escopo, this, classes)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		resultado_expressao = computar_expressao(par[1], escopo, this, classes)
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
		resultado_expressao = computar_expressao(par[0], escopo, this, classes)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		resultado_expressao = computar_expressao(par[1], escopo, this, classes)
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
		resultado_expressao = computar_expressao(par[0], escopo, this, classes)
		valor1 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor1.classe == "Exception":
			resultado = valor1
			return [resultado, escopo]
		resultado_expressao = computar_expressao(par[1], escopo, this, classes)
		valor2 = resultado_expressao[0]
		escopo = resultado_expressao[1]
		if valor2.classe == "Exception":
			resultado = valor2
			return [resultado, escopo]
		if valor1.classe != valor2.classe or valor1.classe != "int":
			resultado = ExceptionJDT.new("", "O operador <= não é definido para o(s) tipo(s) de argumentos " + valor1.classe + ", " + valor2.classe)
			return [resultado, escopo]
		resultado = valor1.less_than_or_equal(valor2)

	elif expressao.nome.equals(StringJDT.new("return")).value:
		resultado_expressao = computar_expressao(par[0], escopo, this, classes)
		resultado = resultado_expressao[0]
		escopo = resultado_expressao[1]
	return [resultado, escopo]

func println(message: String) -> void:
	emit_signal("sout", message)
