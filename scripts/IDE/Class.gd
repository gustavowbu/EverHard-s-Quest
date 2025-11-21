extends Node2D
class_name Class

var nome := ""
var atributos := {}
var metodos := {}

func declarar_atributo(encapsulamento, tipo, nome_atributo: String, valor) -> void:
	atributos[nome_atributo] = {"encapsulamento": encapsulamento, "tipo": tipo, "valor": valor}

func alterar_atributo(nome_atributo: String, valor):
	if not nome_atributo in atributos.keys():
		var erro = Erro.new()
		erro.message = nome_atributo + " não pode ser resolvido ou não é um campo"
		erro.print_message()
		return erro
	if typeof(valor) != atributos[nome_atributo]["tipo"]:
		var erro = Erro.new()
		erro.message = "Incompatibilidade de tipo: não pôde converter " + unmap_tipo(typeof(valor)) + " para " + unmap_tipo(atributos[nome_atributo]["tipo"])
		erro.print_message()
		return erro
	atributos[nome_atributo]["valor"] = valor

func ler_atributo(nome_atributo):
	if not nome_atributo in atributos.keys():
		var erro = Erro.new()
		erro.message = nome_atributo + " não pode ser resolvido ou não é um campo"
		erro.print_message()
		return erro
	return atributos[nome_atributo]["valor"]

func alterar_metodo(encapsulamento, tipo, nome_metodo: String, parametros: Array, algoritmo: Algoritmo) -> void:
	metodos[nome_metodo] = {"encapsulamento": encapsulamento, "tipo": tipo, "parametros": parametros, "algoritmo": algoritmo}

func chamar_metodo(nome_metodo: String, parametros: Array):
	if not nome_metodo in metodos.keys():
		var erro = Erro.new()
		erro.message = "O método " + nome_metodo + "() não é definido para o tipo " + nome
		erro.print_message()
		return erro

	var escopo := {}

	var parametros_algoritmo = metodos[nome_metodo]["parametros"]
	var algoritmo = metodos[nome_metodo]["algoritmo"].copy()

	# Adicionar parâmetros ao escopo
	if len(parametros_algoritmo) != len(parametros):
		var tipos_esperados = parametros_dicts_tipos_to_string(parametros_algoritmo)
		var tipos_passados = parametros_values_tipos_to_string(parametros)
		return raise_error("O método \"" + nome_metodo + "(" + tipos_esperados + ")\" na classe " + nome + " não é aplicável para os argumentos (" + tipos_passados + ")")
	for i in range(len(parametros_algoritmo)):
		var tipo = parametros_algoritmo[i]["tipo"]
		var nome_parametro = parametros_algoritmo[i]["nome"]
		var valor = parametros[i]
		if tipo != typeof(valor):
			var tipos_esperados = parametros_dicts_tipos_to_string(parametros_algoritmo)
			var tipos_passados = parametros_values_tipos_to_string(parametros)
			return raise_error("O método \"" + nome + "(" + tipos_esperados + ")\" na classe " + nome + " não é aplicável para os argumentos (" + tipos_passados + ")")
		escopo[nome_parametro] = {"tipo": tipo, "valor": valor}

	# Computar expressões
	for expressao in algoritmo.expressoes:
		var resultado
		resultado = computar_expressao(expressao, escopo)
		if is_error(resultado):
			return resultado
		if expressao.nome == "return":
			return resultado.parametros[0]

func computar_expressao(expressao, escopo: Dictionary):
	if typeof(expressao) != 24:
		return expressao
	if expressao.get_classe() != "Expressao":
		return expressao
	var expressao_nome = expressao.nome
	var par = expressao.parametros
	var valor1
	var valor2
	if expressao_nome == "declare":
		if par[1] in escopo.keys():
			return raise_error("Variável local \"" + par[0] + "\" duplicada")
		escopo[par[1]] = {"tipo": par[0], "valor": null}
	elif expressao_nome == "assign":
		if not par[0] in escopo.keys():
			if par[0].begins_with("this."):
				return raise_error(par[0].substr(5) + " não pode ser resolvido ou não é um campo")
			else:
				return raise_error(par[0] + " não pode ser resolvido a uma variável")
		valor1 = computar_expressao(par[1], escopo)
		if is_error(valor1):
			return valor1
		if par[0].begins_with("this."):
			alterar_atributo(par[0].substr(5), valor1)
		else:
			if escopo[par[0]]["tipo"] != typeof(valor1):
				return raise_error("Incompatibilidade de tipo: não pôde converter " + unmap_tipo(typeof(valor1)) + " para " + unmap_tipo(escopo[par[0]]["tipo"]))
			escopo[par[0]] = valor1
	elif expressao_nome == "declare & assign":
		if par[1] in escopo.keys():
			return raise_error("Variável local \"" + par[0] + "\" duplicada")
		valor1 = computar_expressao(par[2], escopo)
		if is_error(valor1):
			return valor1
		if par[0] != typeof(valor1):
			return raise_error("Incompatibilidade de tipo: não pôde converter " + unmap_tipo(par[0]) + " para " + unmap_tipo(valor1))
		escopo[par[1]] = {"tipo": par[0], "valor": valor1}
	elif expressao_nome == "addition":
		valor1 = computar_expressao(par[0], escopo)
		valor2 = computar_expressao(par[1], escopo)
		if is_error(valor1):
			return valor1
		if is_error(valor2):
			return valor2
		if not typeof(valor1) in [TYPE_INT, TYPE_STRING] or not typeof(valor2) in [TYPE_INT, TYPE_STRING]:
			var tipo1 = unmap_tipo(typeof(valor1))
			var tipo2 = unmap_tipo(typeof(valor1))
			return raise_error("O operador + não é definido para o(s) tipo(s) de argumentos " + tipo1 + ", " + tipo2)
		if typeof(valor1) == TYPE_STRING or typeof(valor2) == TYPE_STRING:
			valor1 = str(valor1)
			valor2 = str(valor2)
		return valor1 + valor2
	elif expressao_nome == "subtraction":
		valor1 = computar_expressao(par[0], escopo)
		valor2 = computar_expressao(par[1], escopo)
		if is_error(valor1):
			return valor1
		if is_error(valor2):
			return valor2
		if typeof(valor1) != typeof(valor2) or typeof(valor1) != TYPE_INT:
			var tipo1 = unmap_tipo(typeof(valor1))
			var tipo2 = unmap_tipo(typeof(valor1))
			return raise_error("O operador - não é definido para o(s) tipo(s) de argumentos " + tipo1 + ", " + tipo2)
		return valor1 - valor2
	elif expressao_nome == "multiplication":
		valor1 = computar_expressao(par[0], escopo)
		valor2 = computar_expressao(par[1], escopo)
		if is_error(valor1):
			return valor1
		if is_error(valor2):
			return valor2
		if typeof(valor1) != typeof(valor2) or typeof(valor1) != TYPE_INT:
			var tipo1 = unmap_tipo(typeof(valor1))
			var tipo2 = unmap_tipo(typeof(valor1))
			return raise_error("O operador * não é definido para o(s) tipo(s) de argumentos " + tipo1 + ", " + tipo2)
		return valor1 * valor2
	elif expressao_nome == "division":
		valor1 = computar_expressao(par[0], escopo)
		valor2 = computar_expressao(par[1], escopo)
		if is_error(valor1):
			return valor1
		if is_error(valor2):
			return valor2
		if typeof(valor1) != typeof(valor2) or typeof(valor1) != TYPE_INT:
			var tipo1 = unmap_tipo(typeof(valor1))
			var tipo2 = unmap_tipo(typeof(valor1))
			return raise_error("O operador / não é definido para o(s) tipo(s) de argumentos " + tipo1 + ", " + tipo2)
		return valor1 / valor2
	elif expressao_nome == "equals":
		valor1 = computar_expressao(par[0], escopo)
		valor2 = computar_expressao(par[1], escopo)
		if is_error(valor1):
			return valor1
		if is_error(valor2):
			return valor2
		if typeof(valor1) != typeof(valor2):
			var tipo1 = unmap_tipo(typeof(valor1))
			var tipo2 = unmap_tipo(typeof(valor1))
			return raise_error("O operador == não é definido para o(s) tipo(s) de argumentos " + tipo1 + ", " + tipo2)
		return valor1 == valor2
	elif expressao_nome == "greater than":
		valor1 = computar_expressao(par[0], escopo)
		valor2 = computar_expressao(par[1], escopo)
		if is_error(valor1):
			return valor1
		if is_error(valor2):
			return valor2
		if typeof(valor1) != typeof(valor2) or typeof(valor1) != TYPE_INT:
			var tipo1 = unmap_tipo(typeof(valor1))
			var tipo2 = unmap_tipo(typeof(valor1))
			return raise_error("O operador > não é definido para o(s) tipo(s) de argumentos " + tipo1 + ", " + tipo2)
		return valor1 > valor2
	elif expressao_nome == "less than":
		valor1 = computar_expressao(par[0], escopo)
		valor2 = computar_expressao(par[1], escopo)
		if is_error(valor1):
			return valor1
		if is_error(valor2):
			return valor2
		if typeof(valor1) != typeof(valor2) or typeof(valor1) != TYPE_INT:
			var tipo1 = unmap_tipo(typeof(valor1))
			var tipo2 = unmap_tipo(typeof(valor1))
			return raise_error("O operador < não é definido para o(s) tipo(s) de argumentos " + tipo1 + ", " + tipo2)
		return valor1 < valor2
	elif expressao_nome == "greater than or equal":
		valor1 = computar_expressao(par[0], escopo)
		valor2 = computar_expressao(par[1], escopo)
		if is_error(valor1):
			return valor1
		if is_error(valor2):
			return valor2
		if typeof(valor1) != typeof(valor2) or typeof(valor1) != TYPE_INT:
			var tipo1 = unmap_tipo(typeof(valor1))
			var tipo2 = unmap_tipo(typeof(valor1))
			return raise_error("O operador >= não é definido para o(s) tipo(s) de argumentos " + tipo1 + ", " + tipo2)
		return valor1 >= valor2
	elif expressao_nome == "less than or equal":
		valor1 = computar_expressao(par[0], escopo)
		valor2 = computar_expressao(par[1], escopo)
		if is_error(valor1):
			return valor1
		if is_error(valor2):
			return valor2
		if typeof(valor1) != typeof(valor2) or typeof(valor1) != TYPE_INT:
			var tipo1 = unmap_tipo(typeof(valor1))
			var tipo2 = unmap_tipo(typeof(valor1))
			return raise_error("O operador <= não é definido para o(s) tipo(s) de argumentos " + tipo1 + ", " + tipo2)
		return valor1 <= valor2
	elif expressao_nome == "read":
		if par[0].begins_with("this."):
			return ler_atributo(par[0].substr(5))
		else:
			if not par[0] in escopo.keys():
				return raise_error(par[0] + " não pode ser resolvido a uma variável")
			return escopo[par[0]]["valor"]
	elif expressao_nome == "value":
		return par[0]
	elif expressao_nome == "return":
		expressao.parametros = [computar_expressao(par[0], escopo)]
		return expressao

func raise_error(message: String, nome_erro: String = "Erro") -> Erro:
	var erro = Erro.new()
	erro.nome = nome_erro
	erro.message = message
	erro.print_message()
	return erro

func is_error(valor) -> bool:
	if typeof(valor) != 24:
		return false
	return valor.get_classe() == "Erro"

func unmap_tipo(tipo):
	if tipo == TYPE_INT:
		return "int"
	if tipo == TYPE_STRING:
		return "String"
	if tipo == TYPE_BOOL:
		return "boolean"

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


func get_classe() -> String:
	return "Class"
