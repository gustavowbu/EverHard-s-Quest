extends Objeto
class_name Slime

func _ready():
	super._ready() # chama o ready do Objeto.gd
	$AnimatedSprite2D.play("walk")
	
	# tenta pegar o jogador pelo grupo
	var jogador = get_tree().get_first_node_in_group("player")

	if jogador:
		print("🎉 Jogador encontrado: ", jogador.name)
	else:
		print("❌ Jogador NÃO encontrado! (confirme o grupo player no jogador.tscn)")

func _init(metodos_in := [], codigo_in := "") -> void:
	nome = "Slime"
	metodos = metodos_in
	codigo = codigo_in

	vida = 10
	forca = 3
	defesa = 6

	#atributos = {}
	testes = {
		"atirar gosma": [],
		"pular": [
			{"this.tamanho": 1, "x": 1, "esperado": 1},
			{"this.tamanho": 3, "x": 4, "esperado": 12},
			{"this.tamanho": 5, "x": 2, "esperado": 10}
		]
	}
