extends Objeto
class_name Cobra

func _init() -> void:
	nome = "Cobra"
	pronomes = "ela/dela"

	vida_max = 50.0
	vida = 50.0
	forca = 15.0
	defesa = 6.0

	#atributos = {}
	testes = {
		"atirar gosma": [],
		"pular": [
			{"this.tamanho": 1, "x": 1, "esperado": 1},
			{"this.tamanho": 3, "x": 4, "esperado": 12},
			{"this.tamanho": 5, "x": 2, "esperado": 10}
		]
	}

	sprites = {
		"32x32_down": "res://sprites/Objetos/Floresta/Cobra/32x32-cobra-down.png",
		"32x32_right": "res://sprites/Objetos/Floresta/Cobra/32x32-cobra-right.png",
		"32x32_up": "res://sprites/Objetos/Floresta/Cobra/32x32-cobra-up.png",
		"32x32_left": "res://sprites/Objetos/Floresta/Cobra/32x32-cobra-left.png",

		"64x64_front": "res://sprites/Objetos/Floresta/Cobra/64x64-cobra-front.png",
		"64x64_back": "res://sprites/Objetos/Floresta/Cobra/64x64-cobra-back.png"
	}
