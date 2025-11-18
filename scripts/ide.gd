extends CanvasLayer

@onready var editor = $"Text Area/CodeEdit"

func _ready() -> void:
	editor.grab_focus()

var atributos := {}
var tipos_atributos := {}

var metodos := {}
var tipos_metodos := {}
var parametros_metodos := {}
var tipos_parametros_metodos := {}
# Exemplo:
#var metodos := {"numero": [ \
# ["declare", ["y"]], \
# ["assign", ["y", 2]], \
# ["return", ["add", ["read, "y"]], 3]]}

var simbolos = ["(", ")", "[", "]", "{", "}", ",", ".", ";", "=", "-", "+", "*", "/", "\""]
var letras = "abcdefghijklmnopqrstuvwxyz"
var letrasLU = letras + letras.to_upper()
var numeros = "0123456789"
var nome_chars = letrasLU + numeros + "_"
var encapsulamentos = ["public", "private", "protected"]
var tipos_normais = ["int", "String", "boolean"]
var tipos = tipos_normais + ["void"]

var palavras_reservadas = encapsulamentos + tipos + ["class", "return", "if", "for", "while"]

func _on_run_button_button_down() -> void:
	var code: String = editor.text
	parse_code(code)

func parse_code(code) -> void:
	# Adicionar espaços antes e depois do código
	code = " " + code + " "

	# Adicionar espaços separando os símbolos
	for i in range(len(simbolos)):
		code = code.replace(simbolos[i], " " + simbolos[i] + " ")

	# Ignorar quebras de linha, tabs e espaços duplos
	code = code.replace("\n", " ")
	code = code.replace("	", " ")
	var last_code = code
	while true:
		code = code.replace("  ", " ")
		if code == last_code:
			break
		last_code = code

	# Remover espaços antes e depois do código
	code = code.substr(1, len(code)-2)

	# Transformar em lista de palavras
	var code_array: Array = code.split(" ")

	# Começar a ler o código em si
	var i = 0;

	# Checar se o código começa com "public class"
	if len(code_array) <= i or code_array[i] != "public":
		erro("Classe deve ser 'public'")
		return
	i += 1
	if len(code_array) <= i or code_array[i] != "class":
		erro("Classe deve ser iniciada com 'class'")
		return
	i += 1

	# Ler o nome da classe
	if len(code_array) <= i or not is_valid_name(code_array[i]):
		erro("Nome de classe deve conter apenas letras e _")
		return
	i += 1

	# Ler as chaves { }
	if len(code_array) <= i+1 or code_array[i] != "{" or code_array[-1] != "}":
		erro("Código de classe deve estar entre chaves: '{' e '}'")
		return
	i += 1

	# Ler atributos e métodos
	while true:
		# Ver se terminou a classe
		if code_array[i] == "}":
			i += 1
			break
		# Ver se começa com public/private/protected
		if code_array[i] in encapsulamentos:
			i += 1
		# Ler o tipo do atributo ou método
		if not code_array[i] in tipos:
			erro("Tipo do atributo ou método inválido")
			return
		var tipo = code_array[i]
		i += 1
		# Ler o nome do atributo ou método
		if not is_valid_name(code_array[i]):
			erro("Nome do atributo ou método '" + code_array[i] + "' inválido")
			return
		var nome = code_array[i]
		i += 1

		# Ver se é seguido por '('
		if code_array[i] == "(": # método
			i += 1
			var i_met = parse_metodo(code_array.slice(i), tipo, nome)
			if i_met == -1:
				return
			i += i_met
		else: # atributo
			var i_atr = parse_atributo(code_array.slice(i), tipo, nome)
			if i_atr == -1:
				return
			i += i_atr
	if len(code_array) > i:
		erro("Existe código fora da declaração da classe")
		return

	#print("código: ", code_array)

	#print("atributos: ", atributos)
	#print("tipos dos atributos: ", tipos_atributos)

	#print("métodos: ", metodos)
	#print("tipos dos métodos: ", tipos_metodos)
	#print("parâmetros dos métodos: ", parametros_metodos)
	#print("tipos dos parâmetros dos métodos: ", tipos_parametros_metodos)

	print("Chamando método somar com x=3: ", chamar_metodo("somar", [3]))

func parse_atributo(code_array: Array, tipo: String, nome: String) -> int:
	var i = 0
	if tipo == "void":
		erro("Atributo não pode ter o tipo 'void'")
		return -1
	# Ler valor do atributo
	var variavel = parse_declaracao_variavel(code_array.slice(i), tipo, nome, true)
	if variavel == []:
		return -1
	var valor = variavel[0]
	i += variavel[1]
	# Adicionar atributo
	alterar_atributo(nome, tipo, valor)
	return i

func parse_metodo(code_array: Array, tipo: String, nome: String) -> int:
	var i = 0
	# Ler parâmetros
	var parametros = []
	var tipos_parametros = []
	while true:
		# Caso nunca encontrar um ")"
		if i == len(code_array):
			erro("')' não encontrado")
			return -1
		# Ver se terminou os parâmetros
		if code_array[i] == ")":
			i += 1
			break
		# Ler o tipo do parâmetro
		if not code_array[i] in tipos_normais:
			erro("Tipo '" + code_array[i] + "'de parâmetro inválido")
			return -1
		tipos_parametros.append(code_array[i])
		i += 1
		# Ler o nome do parâmetro
		if not is_valid_name(code_array[i]):
			erro("Nome do parâmetro '" + code_array[i] + "' inválido")
			return -1
		parametros.append(code_array[i])
		i += 1
	# Ler abre chaves
	if code_array[i] != "{":
		erro("Declaração de método deve haver '{'")
		return -1
	i += 1
	# Ler algoritmo
	var algoritmo = []
	while true:
		# Caso nunca encontrar um "}"
		if i == len(code_array):
			erro("'}' não encontrado")
			return -1
		# Ver se terminou o algoritmo
		if code_array[i] == "}":
			i += 1
			break
		var expressao_raw = []
		while true:
			# Caso nunca encontrar um ";"
			if i == len(code_array):
				erro("';' não encontrado")
				return -1
			# Ver se terminou a expressão
			if code_array[i] == ";":
				expressao_raw.append(code_array[i])
				i += 1
				break
			expressao_raw.append(code_array[i])
			i += 1
		var expressao = parse_expressao(expressao_raw)
		if expressao == []:
			return -1
		algoritmo.append(expressao)
	adicionar_metodo(nome, tipo, parametros, tipos_parametros, algoritmo)
	return i

func parse_expressao(expressao_raw: Array):
	var expressao
	if len(expressao_raw) == 0:
		erro("Expressão vazia")
		return []
	var w = expressao_raw[0]
	# Declaração de variável
	if w in tipos_normais:
		expressao = ["declare", []]
		expressao[1].append(w) # tipo da variável
		if not is_valid_name(expressao_raw[1]):
			erro("Nome de variável inválido")
			return []
		expressao[1].append(expressao_raw[1]) # nome da variável
		if expressao_raw[2] == "=":
			expressao[0] = "declare & assign"
			expressao[1].append(parse_expressao(expressao_raw.slice(3)))
	# Acesso a variável
	elif is_valid_name(w):
		if expressao_raw[1] == "+":
			expressao = ["add", []]
			expressao[1].append(["read", [w]])
			expressao[1].append(parse_expressao(expressao_raw.slice(2)))
		elif expressao_raw[1] == "-":
			expressao = ["subtract", []]
			expressao[1].append(["read", [w]])
			expressao[1].append(parse_expressao(expressao_raw.slice(2)))
		elif expressao_raw[1] == "*":
			expressao = ["multiply", []]
			expressao[1].append(["read", [w]])
			expressao[1].append(parse_expressao(expressao_raw.slice(2)))
		elif expressao_raw[1] == "/":
			expressao = ["divide", []]
			expressao[1].append(["read", [w]])
			expressao[1].append(parse_expressao(expressao_raw.slice(2)))
		elif expressao_raw[1] == "=":
			if expressao_raw[2] == "=":
				expressao = ["equals", []]
				expressao[1].append(["read", [w]])
				expressao[1].append(parse_expressao(expressao_raw.slice(3)))
			else:
				expressao = ["assign", [w]]
				expressao[1].append(parse_expressao(expressao_raw.slice(2)))
		elif expressao_raw[1] == ";":
			expressao = ["read", [w]]
		else:
			erro("Chamada de variável inválida")
			return []
	# Operação com int
	elif w.is_valid_int():
		w = int(w)
		if expressao_raw[1] == "+":
			expressao = ["add", [w]]
			expressao[1].append(parse_expressao(expressao_raw.slice(2)))
		elif expressao_raw[1] == "-":
			expressao = ["subtract", [w]]
			expressao[1].append(parse_expressao(expressao_raw.slice(2)))
		elif expressao_raw[1] == "*":
			expressao = ["multiply", [w]]
			expressao[1].append(parse_expressao(expressao_raw.slice(2)))
		elif expressao_raw[1] == "/":
			expressao = ["divide", [w]]
			expressao[1].append(parse_expressao(expressao_raw.slice(2)))
		elif expressao_raw[1] == "=":
			if expressao_raw[2] != "=":
				erro("Operação inválida para int: '='")
				return []
			expressao = ["equals", [w]]
			expressao[1].append(parse_expressao(expressao_raw.slice(3)))
		elif expressao_raw[1] == ";":
			expressao = w
		else:
			erro("Valor inesperado após '" + w + "': " + expressao_raw[1])
			return []
	# Operação com String
	elif w == "\"":
		pass
	# Operação com boolean
	elif w in ["true", "false"]:
		pass
	# return
	elif w == "return":
		expressao = ["return", []]
		expressao[1].append(parse_expressao(expressao_raw.slice(1)))
	else:
		erro("Expressão inválida")
		return []
	return expressao

func parse_declaracao_variavel(code_array: Array, tipo: String, nome: String, is_atributo: bool = false) -> Array:
	""" Retorna o valor da variável e o índex aumentado. """
	var descricao_erro
	if is_atributo:
		descricao_erro = "Valor do atributo '" + nome + "' inválido"
	else:
		descricao_erro = "Valor da variável '" + nome + "' inválido"

	var i = 0
	var valor
	if code_array[i] == "=":
		i += 1
		if tipo == "int": # variável é int
			if not code_array[i].is_valid_int():
				erro(descricao_erro)
				return []
			valor = int(code_array[i])
		elif tipo == "String": # variável é String
			if code_array[i] != "\"":
				erro(descricao_erro)
				return []
			else:
				i += 1
				valor = ""
				while true:
					if len(code_array) == i: # aspas nunca fechadas
						erro("\" não foi fechada")
						return []
					if code_array[i] == "\"": # encontrado fecha aspas
						break
					valor += code_array[i]
					i += 1
		elif tipo == "boolean": # variável é boolean
			if code_array[i] == "true":
				valor = true
			elif code_array[i] == "false":
				valor = false
			else:
				erro(descricao_erro)
				return []
		i += 1
	# Finalizar variável
	if code_array[i] != ";":
		erro("Nenhum ';' encontrado")
		return []

	return [valor, i + 1]

func erro(e: String) -> void:
	print(e)

func is_valid_symbol(w: String) -> bool:
	if w in simbolos:
		return true
	return false

func is_valid_name(w: String) -> bool:
	if w in palavras_reservadas:
		return false

	for i in range(len(w)):
		if i == 0:
			if not w[i] in letrasLU:
				return false
		if not w[i] in nome_chars:
			return false
	return true

func adicionar_classe(classe: String) -> void:
	print("Não implementado ainda")
	print(classe)

func alterar_atributo(nome: String, tipo: String, valor) -> void:
	atributos[nome] = valor
	tipos_atributos[nome] = tipo

func ler_atributo(nome: String):
	return atributos[nome]

func adicionar_metodo(nome: String, tipo: String, parametros: Array, tipos_parametros: Array, algoritmo: Array) -> void:
	metodos[nome] = algoritmo
	tipos_metodos[nome] = tipo
	parametros_metodos[nome] = parametros
	tipos_parametros_metodos[nome] = tipos_parametros

var escopos := {}
func chamar_metodo(nome: String, parametros: Array = []):
	""" Chama um método da classe criada.

	Parâmetros:
	-----------
	nome: Nome do método.
	parametros: Parâmetros do método. Deve ser um array de valores.
	"""

	escopos[nome] = {}

	# Receber os valores dos parâmetros
	var nomes_parametros = parametros_metodos[nome]
	for i in range(len(nomes_parametros)):
		var nome_parametro = nomes_parametros[i]
		escopos[nome][nome_parametro] = parametros[i]

	var algoritmo: Array = metodos[nome]
	for i in range(len(algoritmo)):
		var escopo_nome = nome
		var result = computar_expressao(algoritmo[i], escopo_nome)
		if algoritmo[i][0] == "return":
			return result
		i += 1

func computar_expressao(expressao, escopo_nome):
	if is_expressao(expressao):
		var nome: String = expressao[0]
		var valores: Array = expressao[1]
		if nome == "declare":
			escopos[escopo_nome][valores[1] + "_tipo"] = valores[0]
			escopos[escopo_nome][valores[1]] = null
		elif nome == "declare & assign":
			escopos[escopo_nome][valores[1] + "_tipo"] = valores[0]
			escopos[escopo_nome][valores[1]] = computar_expressao(valores[2], escopo_nome)
		elif nome == "assign":
			escopos[escopo_nome][valores[0]] = computar_expressao(valores[1], escopo_nome)
		elif nome == "read":
			return escopos[escopo_nome][valores[0]]
		elif nome == "add":
			var w1 = computar_expressao(valores[0], escopo_nome)
			var w2 = computar_expressao(valores[1], escopo_nome)
			return w1 + w2
		elif nome == "subtract":
			var w1 = computar_expressao(valores[0], escopo_nome)
			var w2 = computar_expressao(valores[1], escopo_nome)
			return w1 - w2
		elif nome == "multiply":
			var w1 = computar_expressao(valores[0], escopo_nome)
			var w2 = computar_expressao(valores[1], escopo_nome)
			return w1 * w2
		elif nome == "divide":
			var w1 = computar_expressao(valores[0], escopo_nome)
			var w2 = computar_expressao(valores[1], escopo_nome)
			return w1 / w2
		elif nome == "return":
			return computar_expressao(valores[0], escopo_nome)
	else:
		return expressao

func is_expressao(valor) -> bool:
	if typeof(valor) == TYPE_ARRAY and len(valor) == 2 and typeof(valor[0]) == TYPE_STRING and typeof(valor[1]) == TYPE_ARRAY:
		return true
	return false

func string_to_value(w: String): # Não é utilizado
	if w.is_valid_int():
		return int(w)
	if w == "true":
		return true
	if w == "false":
		return false
	return w
