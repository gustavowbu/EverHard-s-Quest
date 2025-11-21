extends Objeto
class_name Slime

func _ready():
	super._ready() # chama o ready do Objeto.gd
	$AnimatedSprite2D.play("walk")

var metodos := {
	"atirar gosma": [],
	"pular": [
		{"this.tamanho": 1, "x": 1, "esperado": 1},
		{"this.tamanho": 3, "x": 4, "esperado": 12},
		{"this.tamanho": 5, "x": 2, "esperado": 10}
	]
}

@export var vida: int = 40
@export var forca: int = 3
@export var multiplicador_ataque: float = 1.0
