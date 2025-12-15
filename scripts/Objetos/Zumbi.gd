extends Objeto
class_name Zumbi

func _init(metodos_in := []) -> void:
	nome = "Zumbi"
	metodos = metodos_in

	vida = 12
	forca = 7
	defesa = 1

	#atributos = {}
	testes = {
		"atirar_gosma": [
			{"nome": "Inimigo", "esperado": "Inimigo mau!"},
			{"nome": "Chefe", "esperado": "Chefe mau!"}
		],
		"pular": [
			{"this.velocidade": 2, "altura": 3, "distancia": 5, "esperado": 7},
			{"this.velocidade": 3, "altura": 10, "distancia": 4, "esperado": 2}
		]
	}

	sprites = {
		"32x32_front": "res://sprites/Objetos/Pedra/32x32-pedra-front.png",
		"32x32_back": "res://sprites/Objetos/Pedra/32x32-pedra-back.png",
		"64x64_front": "res://sprites/Objetos/Pedra/64x64-pedra-front.png",
		"64x64_back": "res://sprites/Objetos/Pedra/64x64-pedra-back.png"
	}
