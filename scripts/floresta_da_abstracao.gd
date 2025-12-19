extends Node2D

func _ready():

	# reposiciona jogador
	if global.player_position != Vector2.ZERO:
		$jogador.global_position = global.player_position

	# remove inimigo derrotado
	for enemy_path in global.enemies_defeated:
		var morto = get_node_or_null(enemy_path)
		if morto:
			morto.queue_free()

			# limpa para não deletar de novo
			global.enemy_name = ""
