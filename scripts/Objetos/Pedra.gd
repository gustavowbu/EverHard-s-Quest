extends Objeto
class_name Pedra

func _init() -> void:
	nome = "Pedra"

	vida_max = 25.0
	vida = 25.0
	forca = 11.0
	defesa = 16.0

	atributos = {"tamanho": 1}
	testes = {
		"jogar": [
			{"x": 2, "esperado": 4},
			{"x": 5, "esperado": 10},
			{"x": 11, "esperado": 22},
		],
		"aumentar": [
			{"this.tamanho": 3, "esperado": 4},
			{"this.tamanho": 4, "esperado": 5},
			{"this.tamanho": 6, "esperado": 7}
		],
		"bater": [
			{"this.tamanho": 1, "x": 1, "esperado": 1},
			{"this.tamanho": 3, "x": 4, "esperado": 12},
			{"this.tamanho": 5, "x": 2, "esperado": 10}
		]
	}

	sprites = {
		"32x32_down": "res://sprites/Objetos/Pedra/32x32-pedra-down.png",
		"32x32_right": "res://sprites/Objetos/Pedra/32x32-pedra-down.png",
		"32x32_up": "res://sprites/Objetos/Pedra/32x32-pedra-down.png",
		"32x32_left": "res://sprites/Objetos/Pedra/32x32-pedra-down.png",

		"64x64_front": "res://sprites/Objetos/Pedra/64x64-pedra-front.png",
		"64x64_back": "res://sprites/Objetos/Pedra/64x64-pedra-back.png"
	}

func jogar(x: int) -> int:
	return x * 2

func aumentar() -> void:
	atributos["tamanho"] += 1

func bater(x: int) -> int:
	return x * atributos["tamanho"]
