extends Node2D
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

func parse_code(code: String):
	var code_array = code_to_array(code)
	var classe = parse_code_array(code_array)
	if is_error(classe):
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

func parse_code_array(code: Array):
	var classe = Class.new()
	var i = 0
	# Parte 1: Ler o encapsulamento da classe e a palavra-chave 'class'
	if len(code) == 0:
		return raise_syntax_error("Classe não pode ser resolvida a um tipo")
	if code[i] in encapsulamentos:
		i += 1
	if len(code) == 1 or code[i] != "class":
		return raise_syntax_error("Classe não pode ser resolvida a um tipo")
	i += 1
	# Parte 2: Ler o nome da classe e o '{'
	if len(code) == i:
		return raise_syntax_error("Classe não pode ser resolvida a um tipo")
	if not is_valid_name(code[i]):
		return raise_syntax_error("Erro no token \"" + code[i] + "\", declarador de classe inválido")
	classe.nome = code[i]
	i += 1
	if len(code) == i:
		return raise_syntax_error("Insira o \"CorpoDaClasse\" para completar a \"UnidadeDeCompilacao\"")
	if code[i] != "{":
		return raise_syntax_error("Insira o \"CorpoDaClasse\" para completar a \"UnidadeDeCompilacao\"")
	i += 1
	# Parte 3: Ler o corpo da classe
	var fechou_chaves = false
	var estado := "encapsulamento"
	var encapsulamento
	var tipo
	var nome
	var corpo = []
	var parametros := []
	var parametro_tipo
	var parametro_nome
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
					i += 1
					continue
			fechou_chaves = true
			break
		if estado == "encapsulamento":
			if w in encapsulamentos:
				encapsulamento = w
			else:
				encapsulamento = null
				i -= 1
			estado = "tipo"
		elif estado == "tipo":
			if not w in tipos:
				return raise_syntax_error(w + " não pode ser resolvido a um tipo")
			tipo = map_tipo(w)
			estado = "nome"
		elif estado == "nome":
			if not is_valid_name(w):
				return raise_syntax_error("Erro no token \"" + w + "\", esperava Identificador")
			nome = w
			estado = "corpo_inicio"
		elif estado == "corpo_inicio":
			if w == ";":
				corpo = null
				if unmap_tipo(tipo) == "void":
					return raise_syntax_error("void é um tipo inválido para a variável " + nome)
				classe.declarar_atributo(encapsulamento, tipo, nome, corpo)
				corpo = []
				estado = "encapsulamento"
			elif w == "=":
				if unmap_tipo(tipo) == "void":
					return raise_syntax_error("void é um tipo inválido para a variável " + nome)
				estado = "corpo_valor"
			elif w == "(":
				estado = "corpo_parametros_tipo"
			else:
				return raise_syntax_error("Erro no token \"" + w + "\", esperava ;")
		elif estado == "corpo_valor":
			if w == ";":
				corpo.append(w)
				var valor = classe.computar_expressao(parse_expressao(corpo), {})
				if is_error(valor):
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
					return raise_syntax_error("O método " + nome + "() da classe " + classe.nome + " refere ao tipo faltante " + w)
				return raise_syntax_error("O método " + nome + "() não é definido para a classe " + classe.nome)
			parametro_tipo = map_tipo(w)
			estado = "corpo_parametros_nome"
		elif estado == "corpo_parametros_nome":
			if w == ")":
				return raise_syntax_error("Insira \"IdDeDeclaradorDeVariavel\" para completar a ListaFormalDeParametros")
			if not is_valid_name(w):
				return raise_syntax_error("Erro no token \"" + w + "\", IdDeDeclaradorDeVariavel inválido")
			parametro_nome = w
			parametros.append({"tipo": parametro_tipo, "nome": parametro_nome})
			parametro_tipo = ""
			parametro_nome = ""
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
				if not is_algoritmo(algoritmo):
					return algoritmo
				classe.alterar_metodo(encapsulamento, tipo, nome, parametros, algoritmo)
				parametros = []
				corpo = []
				estado = "encapsulamento"
				i += 1
				continue
			corpo.append(w)
		i += 1
	if not fechou_chaves:
		return raise_syntax_error("Insira \"}\" para completar o CorpoDaClasse")
	return classe

func parse_expressao(code: Array):
	var expressao = Expressao.new()
	var i = 0
	var tipo
	var value
	var estado := "inicio"
	while i != len(code):
		var w: String = code[i]
		if estado == "inicio":
			if w == ";":
				return raise_syntax_error("Erro no token \"=\", expressão esperada após este token")
			elif w.is_valid_int():
				value = int(w)
				estado = "operacao"
			elif w == "\"":
				estado = "string"
			elif w == "true":
				value = true
				estado = "operacao"
			elif w == "false":
				value = false
				estado = "operacao"
			elif w in tipos_var:
				tipo = w
				estado = "nome_variavel"
			elif w == "this":
				estado = "."
			elif w == "return":
				expressao.nome = "return"
				expressao.parametros = [parse_expressao(code.slice(i + 1))]
				break
			elif is_valid_name(w):
				value = Expressao.new()
				value.nome = "read"
				value.parametros = [w]
				estado = "operacao"
			else:
				return raise_syntax_error("Expressão inválida")
		elif estado == "string":
			value = w
			estado = "fecha_aspas"
		elif estado == "fecha_aspas":
			estado = "operacao"
		elif estado == "nome_variavel":
			if not is_valid_name(w):
				return raise_syntax_error("Erro no token \"" + w + "\", esperava IdentificadorDeAtributo")
			value = w
			estado = "variable"
		elif estado == "variable":
			if w == ";":
				expressao.nome = "declare"
				expressao.parametros = [tipo, value]
				tipo = null
			elif w == "=":
				estado = "operacao"
				expressao.nome = "declare & assign"
				expressao.parametros = [tipo, value, parse_expressao(code.slice(i + 1))]
				tipo = null
			break
		elif estado == ".":
			estado = "nome_atributo"
		elif estado == "nome_atributo":
			if not is_valid_name(w):
				return raise_syntax_error("Erro no token \"" + w + "\", esperava IdentificadorDeAtributo")
			value = Expressao.new()
			value.nome = "read"
			value.parametros = ["this." + w]
			estado = "operacao"
		elif estado == "operacao":
			if w == "+":
				expressao.nome = "addition"
				expressao.parametros = [value, parse_expressao(code.slice(i + 1))]
				break
			elif w == "-":
				expressao.nome = "subtraction"
				expressao.parametros = [value, parse_expressao(code.slice(i + 1))]
				break
			elif w == "*":
				expressao.nome = "multiplication"
				expressao.parametros = [value, parse_expressao(code.slice(i + 1))]
				break
			elif w == "/":
				expressao.nome = "division"
				expressao.parametros = [value, parse_expressao(code.slice(i + 1))]
				break
			elif w == "==":
				expressao.nome = "equals"
				expressao.parametros = [value, parse_expressao(code.slice(i + 1))]
				break
			elif w == ">":
				expressao.nome = "greater than"
				expressao.parametros = [value, parse_expressao(code.slice(i + 1))]
				break
			elif w == "<":
				expressao.nome = "less than"
				expressao.parametros = [value, parse_expressao(code.slice(i + 1))]
				break
			elif w == ">=":
				expressao.nome = "greater than or equal"
				expressao.parametros = [value, parse_expressao(code.slice(i + 1))]
				break
			elif w == "<=":
				expressao.nome = "less than or equal"
				expressao.parametros = [value, parse_expressao(code.slice(i + 1))]
				break
			elif w == "=":
				if typeof(value) != typeof(Expressao):
					return raise_syntax_error("O lado esquerdo de uma atribuição deve ser uma variável")
				expressao.nome = "assign"
				expressao.parametros = [value.parametros[0], parse_expressao(code.slice(i + 1))]
				break
			elif w == ";":
				if typeof(value) == typeof(Expressao): # read
					expressao = value
				else:
					expressao.nome = "value"
					expressao.parametros = [value]
				break
		i += 1
	return expressao

func parse_algoritmo(code: Array):
	var algoritmo = Algoritmo.new()
	var expressao = []
	var i = 0
	while i != len(code):
		var w: String = code[i]
		if w == "}":
			break
		elif w == ";":
			expressao.append(w)
			expressao = parse_expressao(expressao)
			if is_error(expressao):
				return expressao
			algoritmo.expressoes.append(expressao)
			expressao = []
		else:
			expressao.append(w)
		i += 1
	return algoritmo

func raise_error(message: String, nome: String = "Erro") -> Erro:
	var erro = Erro.new()
	erro.nome = nome
	erro.message = message
	erro.print_message()
	return erro

func raise_syntax_error(message: String) -> Erro:
	return raise_error(message, "Erro de sintaxe")

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

func is_error(valor) -> bool:
	if typeof(valor) != 24:
		return false
	return valor.get_classe() == "Erro"

func is_algoritmo(valor) -> bool:
	if typeof(valor) != 24:
		return false
	return valor.get_classe() == "Algoritmo"

func map_tipo(tipo: String):
	if tipo == "int":
		return TYPE_INT
	if tipo == "String":
		return TYPE_STRING
	if tipo == "boolean":
		return TYPE_BOOL
	return tipo

func unmap_tipo(tipo):
	if tipo == TYPE_INT:
		return "int"
	if tipo == TYPE_STRING:
		return "String"
	if tipo == TYPE_BOOL:
		return "boolean"
	return tipo

func parametros_dicts_tipos_to_string(parametros: Array) -> String:
	var parametros_tipos := ""
	for j in range(len(parametros)):
		parametros_tipos += unmap_tipo(parametros[j]["tipo"])
		if j != len(parametros) - 1:
			parametros_tipos += ", "
	return parametros_tipos

func parametros_values_tipos_to_string(parametros: Array) -> String:
	var parametros_tipos := ""
	for j in range(len(parametros)):
		parametros_tipos += unmap_tipo(typeof(parametros[j]))
		if j != len(parametros) - 1:
			parametros_tipos += ", "
	return parametros_tipos
