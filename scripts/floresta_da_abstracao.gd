extends Node2D

func _ready():
	$FadeLayer.fade_in()

	# reposiciona jogador
	if global.player_position != Vector2.ZERO:
		$jogador.global_position = global.player_position

	# remove inimigo derrotado
	if global.inimigo_derrotado != "":
		var morto = get_node_or_null(global.inimigo_derrotado)
		if morto:
			morto.queue_free()
			print("Inimigo removido:", global.inimigo_derrotado)
		
		# limpa para não deletar de novo
		global.inimigo_derrotado = ""
