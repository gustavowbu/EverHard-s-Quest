extends Objeto
class_name Pedra

var atributos = {"tamanho": 1}

func jogar(x: int) -> int:
	return x * 2

func aumentar() -> void:
	atributos["tamanho"] += 1

func bater(x: int) -> int:
	return x * atributos["tamanho"]

var metodos := {
	"jogar": [],
	"aumentar": [],
	"bater": [
		{"this.tamanho": 1, "x": 1, "esperado": 1},
		{"this.tamanho": 3, "x": 4, "esperado": 12},
		{"this.tamanho": 5, "x": 2, "esperado": 10}
	]
}
