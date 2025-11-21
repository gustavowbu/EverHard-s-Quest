extends "res://scripts/Inimigo.gd"
class_name Pedra


var tamanho := 1

func jogar(x: int) -> int:
	return x * 2

func aumentar() -> void:
	tamanho += 1

func bater(x: int) -> int:
	return x * tamanho


var testes := {
	"bater": [
		{ "tamanho": 1, "x": 1, "esperado": 1 },
		{ "tamanho": 3, "x": 4, "esperado": 12 },
		{ "tamanho": 5, "x": 2, "esperado": 10 }
	],
}
