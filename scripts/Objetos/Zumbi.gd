extends Objeto
class_name Zumbi

var metodos := {
	"atirar_gosma": [
		{"nome": "Inimigo", "esperado": "Inimigo mau!"},
		{"nome": "Chefe", "esperado": "Chefe mau!"}
	],
	"pular": [
		{"this.velocidade": 2, "altura": 3, "distancia": 5, "esperado": 7},
		{"this.velocidade": 3, "altura": 10, "distancia": 4, "esperado": 2}
	]
}

@export var vida: int = 20
@export var forca: int = 3
@export var multiplicador_ataque: float = 1.0
