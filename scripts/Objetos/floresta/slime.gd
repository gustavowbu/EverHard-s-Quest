extends Objeto
class_name Slime

func _init(metodos_in := []) -> void:
	nome = "Slime"
	metodos = metodos_in

	vida = 10
	forca = 4
	defesa = 2

	atributos = {
		"massa": 2
	}

	testes = {
		"pular": [
			{"altura": 2, "esperado": 4},
			{"altura": 5, "esperado": 10}
		],
		"dividir": [
			{"this.massa": 4, "esperado": 2},
			{"this.massa": 6, "esperado": 3}
		],
		"grudar": [],
		"derreter": [
			{"this.massa": 3, "esperado": 2}
		]
	}

	sprites = {
		"32x32_front": "res://sprites/Objetos/Slime/32x32-slime-front.png",
		"32x32_back": "res://sprites/Objetos/Slime/32x32-slime-back.png",
		"64x64_front": "res://sprites/Objetos/Slime/64x64-slime-front.png",
		"64x64_back": "res://sprites/Objetos/Slime/64x64-slime-back.png"
	}

func pular(altura: int) -> int:
	return altura * atributos["massa"]

func dividir() -> int:
	atributos["massa"] /= 2
	return atributos["massa"]

func grudar() -> String:
	return "Slime grudou no alvo"

func derreter() -> int:
	atributos["massa"] -= 1
	return atributos["massa"]
