extends Objeto
class_name Zumbi

var metodos := {
	"atirar gosma": [],
	"pular": [
		{"this.tamanho": 1, "x": 1, "esperado": 1},
		{"this.tamanho": 3, "x": 4, "esperado": 12},
		{"this.tamanho": 5, "x": 2, "esperado": 10}
	]
}

@export var vida: int = 20
@export var forca: int = 3
@export var multiplicador_ataque: float = 1.0
