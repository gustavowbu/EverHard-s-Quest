extends Node
class_name Compiler

var simbolos = "()[]{},.;=-+*/\""
var letras = "abcdefghijklmnopqrstuvwxyz"
var letras_all = letras + letras.to_upper()
var numeros = "0123456789"
var nome_chars = letras_all + numeros + "_"
var encapsulamentos = ["public", "private", "protected"]
var tipos_var = ["int", "String", "boolean"]
var tipos = tipos_var + ["void"]

var palavras_reservadas = encapsulamentos + tipos + ["class", "return", "if", "for", "while"]

func parse_code(code: String) -> JavaDataType:
	var code_array := code_to_array(code)
	var classe := parse_code_array(code_array)
	if classe.classe == "Exception":
		return classe
	return classe

func code_to_array(code: String) -> Array:
	# Adicionar espaços antes e depois do código
	code = " " + code + " "

	# Adicionar espaços separando os símbolos
	var in_string = false
	var i = 0
	while i < len(code) - 1:
		if code[i] == "\"":
			if in_string:
				in_string = false
			else:
				in_string = true
		if not in_string:
			if code[i] in simbolos and code[i] != "\"":
				if i != 0:
					if not code[i - 1] + code[i] in ["==", ">=", "<="]:
						if not code[i] + code[i + 1] in ["==", ">=", "<="]:
							code = code.substr(0, i) + " " + code[i] + " " + code.substr(i + 1)
							i += 2
						else:
							code = code.substr(0, i) + " " + code[i] + code[i + 1] + " " + code.substr(i + 2)
							i += 3
				else:
					code = code.substr(0, i) + " " + code[i] + " " + code.substr(i + 1)
					i += 2
			elif code[i] == "\"":
				code = code.substr(0, i + 1) + " " + code.substr(i + 1)
				i += 1
			elif code[i] in ["\n", "\t"]:
				code = code.substr(0, i) + " " + code.substr(i + 1)
			i += 1
		else:
			if code[i] == "\"":
				code = code.substr(0, i) + " " + code.substr(i)
				i += 1
			i += 1

	# Remover espaços duplos
	in_string = false
	i = 0
	while i < len(code) - 1:
		var double = code.substr(i, 2)
		if double[0] == "\"":
			if in_string:
				in_string = false
			else:
				in_string = true
		if double == "  " and not in_string:
			code = code.substr(0, i + 1) + code.substr(i + 2)
		else:
			i += 1

	# Remover o espaço antes do código
	code = code.substr(1)

	# Transformar em lista de palavras
	var code_array: Array = []
	var string = ""
	in_string = false
	i = 0
	while i != len(code):
		if code[i] == "\"":
			if in_string:
				code_array.append(string)
				string = ""
				i += 1
				in_string = false
			else:
				in_string = true
			code_array.append("\"")
			i += 1
			continue
		if not in_string and code[i] == " ":
			code_array.append(string)
			string = ""
		else:
			string += code[i]
		i += 1

	return code_array

func parse_code_array(code: Array) -> JavaDataType:
	var classe = ClassJDT.new()
	var i = 0
	# Parte 1: Ler o encapsulamento da classe e a palavra-chave 'class'
	if len(code) == 0:
		return raise_syntax_error("Classe não pode ser resolvida a um tipo")
	if code[i] in encapsulamentos:
		classe.encapsulamento = StringJDT.new(code[i])
		i += 1
	if len(code) == 1:
		return raise_syntax_error("Classe não pode ser resolvida a um tipo")
	if code[i] != "class":
		return raise_syntax_error("Classe não pode ser resolvida a um tipo")
	i += 1
	# Parte 2: Ler o nome da classe e o '{'
	if len(code) == i:
		return raise_syntax_error("Classe não pode ser resolvida a um tipo")
	if not is_valid_name(code[i]):
		return raise_syntax_error("Erro no token \"" + code[i] + "\", declarador de classe inválido")
	classe.nome = StringJDT.new(code[i])
	i += 1
	if len(code) == i:
		return raise_syntax_error("Insira o \"CorpoDaClasse\" para completar a \"UnidadeDeCompilacao\"")
	if code[i] != "{":
		return raise_syntax_error("Insira o \"CorpoDaClasse\" para completar a \"UnidadeDeCompilacao\"")
	i += 1
	# Parte 3: Ler o corpo da classe
	var fechou_chaves = false
	var estado := "encapsulamento"
	var encapsulamento: JavaDataType
	var estatico = BooleanJDT.new(false)
	var tipo: StringJDT
	var nome: StringJDT
	var corpo := []
	var parametros_tipos := ArrayJDT.new()
	var parametros_nomes := ArrayJDT.new()
	while i != len(code):
		var w = code[i]
		if w == "}" and estado != "corpo_metodo":
			if estado != "encapsulamento":
				if estado == "tipo":
					return raise_syntax_error("Insira TipoDeVariavel para completar as DeclaracoesDoCorpoDaClasse")
				elif estado == "nome":
					return raise_syntax_error("Insira Identificador para completar as DeclaracoesDoCorpoDaClasse")
				elif estado == "corpo_inicio":
					return raise_syntax_error("Insira \";\" para completar as DeclaracoesDoCorpoDaClasse")
				elif estado == "corpo_valor":
					return raise_syntax_error("Erro no token \"=\", esperava ;")
				elif estado == "corpo_parametros_tipo" or "corpo_parametro_nome":
					return raise_syntax_error("Insira \")\" para completar a DeclaracaoDeMetodo")
				elif estado == "corpo_metodo_comeco":
					return raise_syntax_error("Erro no token \"" + w + "\", esperava { após este token")
			fechou_chaves = true
			break
		if estado == "encapsulamento":
			if w in encapsulamentos:
				encapsulamento = StringJDT.new(w)
			else:
				encapsulamento = NullJDT.new()
				i -= 1
			estado = "static"
		elif estado == "static":
			if w == "static":
				estatico = BooleanJDT.new(true)
			else:
				i -= 1
			estado = "tipo"
		elif estado == "tipo":
			if not w in tipos:
				return raise_syntax_error(w + " não pode ser resolvido a um tipo")
			tipo = StringJDT.new(w)
			estado = "nome"
		elif estado == "nome":
			if not is_valid_name(w):
				return raise_syntax_error("Erro no token \"" + w + "\", esperava Identificador")
			nome = StringJDT.new(w)
			estado = "corpo_inicio"
		elif estado == "corpo_inicio":
			if w == ";":
				if tipo.equals(StringJDT.new("void")):
					return raise_syntax_error("void é um tipo inválido para a variável " + nome.repr())
				classe.declarar_atributo(encapsulamento, tipo, nome, NullJDT.new())
				estado = "encapsulamento"
			elif w == "=":
				if tipo.repr() == "void":
					return raise_syntax_error("void é um tipo inválido para a variável " + nome.repr())
				estado = "corpo_valor"
			elif w == "(":
				estado = "corpo_parametros_tipo"
			else:
				return raise_syntax_error("Erro no token \"" + w + "\", esperava ;")
		elif estado == "corpo_valor":
			if w == ";":
				corpo.append(w)
				corpo.append("}")
				corpo.insert(0, "return")
				var algoritmo_atributo = parse_algoritmo(corpo)
				var valor = algoritmo_atributo.exec()[0]
				if valor.classe == "Exception":
					return valor
				classe.declarar_atributo(encapsulamento, tipo, nome, valor)
				corpo = []
				estado = "encapsulamento"
				i += 1
				continue
			corpo.append(w)
		elif estado == "corpo_parametros_tipo":
			if w == ")":
				estado = "corpo_metodo_comeco"
				i += 1
				continue
			if not w in tipos_var:
				if w != "void":
					return raise_syntax_error("O método " + nome.repr() + "() da classe " + classe.nome.repr() + " refere ao tipo faltante " + w)
				return raise_syntax_error("O método " + nome.repr() + "() não é definido para a classe " + classe.nome.repr())
			parametros_tipos.append(StringJDT.new(w))
			estado = "corpo_parametros_nome"
		elif estado == "corpo_parametros_nome":
			if w == ")":
				return raise_syntax_error("Insira \"IdDeDeclaradorDeVariavel\" para completar a ListaFormalDeParametros")
			if not is_valid_name(w):
				return raise_syntax_error("Erro no token \"" + w + "\", IdDeDeclaradorDeVariavel inválido")
			parametros_nomes.append(StringJDT.new(w))
			estado = "corpo_parametros_virgula"
		elif estado == "corpo_parametros_virgula":
			if w == ")":
				estado = "corpo_metodo_comeco"
				i += 1
				continue
			if w != ",":
				return raise_syntax_error("Erro no token \"" + w + "\", esperava , após este token")
			estado = "corpo_parametros_tipo"
		elif estado == "corpo_metodo_comeco":
			if w != "{":
				return raise_syntax_error("Erro no token \"" + w + "\", esperava { após este token")
			estado = "corpo_metodo"
		elif estado == "corpo_metodo":
			if w == "}":
				corpo.append(w)
				var algoritmo = parse_algoritmo(corpo)
				if algoritmo.classe == "Exception":
					return algoritmo
				classe.declarar_metodo(encapsulamento, estatico, tipo, nome, parametros_tipos, parametros_nomes, algoritmo)
				parametros_tipos = ArrayJDT.new()
				parametros_nomes = ArrayJDT.new()
				corpo = []
				estado = "encapsulamento"
				i += 1
				continue
			corpo.append(w)
		i += 1
	if not fechou_chaves:
		return raise_syntax_error("Insira \"}\" para completar o CorpoDaClasse")
	return classe

func parse_expressao(code: Array) -> JavaDataType:
	var expressao = ExpressionJDT.new()
	var i = 0
	var tipo: JavaDataType
	var value: JavaDataType
	var estado := "inicio"
	while i != len(code):
		var w: String = code[i]
		if estado == "inicio":
			if w == ";":
				return raise_syntax_error("Erro no token \"=\", expressão esperada após este token")
			elif w.is_valid_int():
				value = ExpressionJDT.new()
				value.nome = StringJDT.new("value")
				value.parametros = ArrayJDT.new([IntJDT.new(int(w))])
				estado = "operacao"
			elif w == "\"":
				estado = "string"
			elif w == "true":
				value = ExpressionJDT.new()
				value.nome = StringJDT.new("value")
				value.parametros = ArrayJDT.new([BooleanJDT.new(true)])
				estado = "operacao"
			elif w == "false":
				value = ExpressionJDT.new()
				value.nome = StringJDT.new("value")
				value.parametros = ArrayJDT.new([BooleanJDT.new(false)])
				estado = "operacao"
			elif w in tipos_var:
				tipo = StringJDT.new(w)
				estado = "nome_variavel"
			elif w == "this":
				estado = "."
			elif w == "return":
				expressao.nome = StringJDT.new("return")
				expressao.parametros = ArrayJDT.new([parse_expressao(code.slice(i + 1))])
				break
			elif is_valid_name(w):
				value = ExpressionJDT.new(StringJDT.new("read"), ArrayJDT.new([StringJDT.new(w)]))
				estado = "operacao"
			else:
				return raise_syntax_error("Expressão inválida")
		elif estado == "string":
			value = ExpressionJDT.new()
			value.nome = StringJDT.new("value")
			value.parametros = ArrayJDT.new([StringJDT.new(w)])
			estado = "fecha_aspas"
		elif estado == "fecha_aspas":
			# Não é necessário tratar exceções aqui, pois sempre vai haver um " nesse estado
			estado = "operacao"
		elif estado == "nome_variavel":
			if not is_valid_name(w):
				return raise_syntax_error("Erro no token \"" + w + "\", esperava IdentificadorDeAtributo")
			value = StringJDT.new(w)
			estado = "variable"
		elif estado == "variable":
			if w == ";":
				expressao.nome = StringJDT.new("declare")
				expressao.parametros = ArrayJDT.new([tipo, value])
				tipo = NullJDT.new()
			elif w == "=":
				estado = "operacao"
				expressao.nome = StringJDT.new("declare and assign")
				expressao.parametros = ArrayJDT.new([tipo, value, parse_expressao(code.slice(i + 1))])
				tipo = NullJDT.new()
			break
		elif estado == ".":
			estado = "nome_atributo"
		elif estado == "nome_atributo":
			if not is_valid_name(w):
				return raise_syntax_error("Erro no token \"" + w + "\", esperava IdentificadorDeAtributo")
			value = ExpressionJDT.new(StringJDT.new("read"), ArrayJDT.new([StringJDT.new("this." + w)]))
			estado = "operacao"
		elif estado == "operacao":
			if w == "+":
				expressao.nome = StringJDT.new("addition")
				expressao.parametros = ArrayJDT.new([value, parse_expressao(code.slice(i + 1))])
				break
			elif w == "-":
				expressao.nome = StringJDT.new("subtraction")
				expressao.parametros = ArrayJDT.new([value, parse_expressao(code.slice(i + 1))])
				break
			elif w == "*":
				expressao.nome = StringJDT.new("multiplication")
				expressao.parametros = ArrayJDT.new([value, parse_expressao(code.slice(i + 1))])
				break
			elif w == "/":
				expressao.nome = StringJDT.new("division")
				expressao.parametros = ArrayJDT.new([value, parse_expressao(code.slice(i + 1))])
				break
			elif w == "==":
				expressao.nome = StringJDT.new("equals")
				expressao.parametros = ArrayJDT.new([value, parse_expressao(code.slice(i + 1))])
				break
			elif w == ">":
				expressao.nome = StringJDT.new("greater than")
				expressao.parametros = ArrayJDT.new([value, parse_expressao(code.slice(i + 1))])
				break
			elif w == "<":
				expressao.nome = StringJDT.new("less than")
				expressao.parametros = ArrayJDT.new([value, parse_expressao(code.slice(i + 1))])
				break
			elif w == ">=":
				expressao.nome = StringJDT.new("greater than or equal")
				expressao.parametros = ArrayJDT.new([value, parse_expressao(code.slice(i + 1))])
				break
			elif w == "<=":
				expressao.nome = StringJDT.new("less than or equal")
				expressao.parametros = ArrayJDT.new([value, parse_expressao(code.slice(i + 1))])
				break
			elif w == "=":
				if value.classe != "Expression":
					return raise_syntax_error("O lado esquerdo de uma atribuição deve ser uma variável")
				expressao.nome = StringJDT.new("assign")
				expressao.parametros = ArrayJDT.new([value.parametros.getElement(IntJDT.new(0)), parse_expressao(code.slice(i + 1))])
				break
			elif w == ";":
				if value.classe == "Expression": # read
					expressao = value
				else:
					expressao.nome = StringJDT.new("value")
					expressao.parametros = ArrayJDT.new([value])
				break
		i += 1
	return expressao

func parse_algoritmo(code: Array) -> JavaDataType:
	var algoritmo := AlgorithmJDT.new()
	var expressao_array := []
	var expressao: JavaDataType
	var i = 0
	var completou_ponto_e_virgula := false
	while i != len(code):
		var w: String = code[i]
		if w == "}":
			break
		elif w == ";":
			completou_ponto_e_virgula = true
			expressao_array.append(w)
			expressao = parse_expressao(expressao_array)
			if expressao.classe == "Exception":
				return expressao
			algoritmo.expressoes.append(expressao)
			expressao_array = []
		else:
			completou_ponto_e_virgula = false
			expressao_array.append(w)
		i += 1
	if not completou_ponto_e_virgula:
		return raise_syntax_error("insira \";\" para completar a Expressão")
	return algoritmo

func raise_error(nome: String = "Erro", message: String = "") -> ExceptionJDT:
	return ExceptionJDT.new(nome, message)

func raise_syntax_error(message: String) -> ExceptionJDT:
	return raise_error("Erro de sintaxe", message)

func is_valid_name(w: String) -> bool:
	if w in palavras_reservadas:
		return false

	for i in range(len(w)):
		if i == 0:
			if not w[i] in letras_all:
				return false
		if not w[i] in nome_chars:
			return false
	return true
