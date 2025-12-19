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
		"crescer": [
			{"this.galhos": 1, "esperado": 10},
			{"this.galhos": 2, "esperado": 20},
			{"this.galhos": 34, "esperado": 340},
		],
		"quebrarGalho": [
			{"esperado": "Galho quebrado"}
		],
		"fotossintese": [
			{"this.altura": 3, "esperado": 4},
			{"this.altura": 4, "esperado": 5},
			{"this.altura": 6, "esperado": 7}
		],
		"cair": [
			{"this.altura": 3, "this.galhos": 4, "esperado": 7},
			{"this.altura": 2, "this.galhos": 9, "esperado": 11},
			{"this.altura": 5, "this.galhos": 1, "esperado": 6},
		],
		"balancar": [
			{"nome": "Alexandre", "esperado": "Alexandre, o Grande!"},
			{"nome": "Paulo", "esperado": "Paulo, o Grande!"},
			{"nome": "Rafael", "esperado": "Rafael, o Grande!"}
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
