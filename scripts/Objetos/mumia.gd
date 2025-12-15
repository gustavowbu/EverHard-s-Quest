extends Objeto
class_name Mumia

@export var vida: int = 35
@export var forca: int = 4
@export var poeira: int = 2
@export var maldicao_ativa: bool = false

func enfaixar(alvo: String) -> String:
	return alvo + " foi enfaixado!"

func lancar_maldicao(x: int) -> int:
	maldicao_ativa = true
	return x * poeira

func tossir_poeira(dano_base: int) -> int:
	return dano_base + poeira

var metodos := {
	"enfaixar": [
		{"alvo": "Aventureiro", "esperado": "Aventureiro foi enfaixado!"},
		{"alvo": "Heroi", "esperado": "Heroi foi enfaixado!"}
	],
	"lancar_maldicao": [
		{"this.poeira": 2, "x": 3, "esperado": 6},
		{"this.poeira": 5, "x": 2, "esperado": 10}
	],
	"tossir_poeira": [
		{"this.poeira": 2, "dano_base": 4, "esperado": 6},
		{"this.poeira": 3, "dano_base": 1, "esperado": 4}
	]
}
