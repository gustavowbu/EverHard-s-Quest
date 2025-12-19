extends Objeto
class_name Cobra

func _init() -> void:
	nome = "Cobra"
	pronomes = "ela/dela"

	vida_max = 50.0
	vida = 50.0
	forca = 15.0
	defesa = 6.0

	atributos = {
	"veneno": 3,
	"comprimento": 2,
	"energia": 4
}

	testes = {
		"rastejar": [
			{"this.energia": 4, "esperado": 3},
			{"this.energia": 1, "esperado": 0}
		],

	"atacar": [
		{"this.veneno": 3, "this.comprimento": 2, "esperado": 6},
		{"this.veneno": 5, "this.comprimento": 4, "esperado": 20}
	],

	"enrolar": [
		{"esperado": "Cobra enrolou o alvo"}
	],

	"aumentarVeneno": [
		{"this.veneno": 3, "esperado": 4},
		{"this.veneno": 7, "esperado": 8}
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
