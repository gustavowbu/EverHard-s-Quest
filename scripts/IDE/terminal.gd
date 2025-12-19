extends Node2D

var linhas = []

func adicionar_linha(linha: String) -> void:
	linhas.append(linha)
	alterar_terminal(linhas)

func alterar_terminal(linhas_in: Array) -> void:
	var linhas_string = ""
	if len(linhas_in) > 5:
		linhas_in = linhas_in.slice(len(linhas_in) - 5, len(linhas_in))
	for i in range(len(linhas_in)):
		if i != 0:
			linhas_string += "\n"
		linhas_string += linhas_in[i]
	$Text.text = linhas_string

func limpar() -> void:
	linhas = []
