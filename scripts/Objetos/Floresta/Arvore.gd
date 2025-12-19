extends Objeto
class_name Arvore

func _init() -> void:
	nome = "Arvore"
	pronomes = "ela/dela"

	vida_max = 100.0
	vida = 100.0
	forca = 3.0
	defesa = 20.0

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
		"32x32_down": "res://sprites/Objetos/Floresta/Arvore/32x32-arvore-down.png",
		"32x32_right": "res://sprites/Objetos/Floresta/Arvore/32x32-arvore-down.png",
		"32x32_up": "res://sprites/Objetos/Floresta/Arvore/32x32-arvore-down.png",
		"32x32_left": "res://sprites/Objetos/Floresta/Arvore/32x32-arvore-down.png",

		"64x64_front": "res://sprites/Objetos/Floresta/Arvore/64x64-arvore-front.png",
		"64x64_back": "res://sprites/Objetos/Floresta/Arvore/64x64-arvore-back.png"
	}
