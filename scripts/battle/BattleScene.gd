extends Node

@onready var ui = $BattleUI

var turno := "player" # Até agora isso não é utilizado. Caso continue assim, remova isso
var objeto = global.objetos[global.objetos.keys()[0]]
var inimigo = global.enemy

func _ready():
	$FadeLayer.fade_in()

	$BattleUI.connect("attack", _on_move)
	var metodos = objeto.metodos
	if len(metodos) >= 1:
		$BattleUI/BoxPanel/FightBox/Attack1.text = metodos[0]
	if len(metodos) >= 2:
		$BattleUI/BoxPanel/FightBox/Attack2.text = metodos[1]
	if len(metodos) >= 3:
		$BattleUI/BoxPanel/FightBox/Attack3.text = metodos[2]
	if len(metodos) >= 4:
		$BattleUI/BoxPanel/FightBox/Attack4.text = metodos[3]

	$ObjectMon.texture = load(objeto.sprites["64x64_back"])
	$EnemyMon.texture = load(inimigo.sprites["64x64_front"])

func _on_move(nome_metodo: String):
	if ui.turno == "player":
		var poder = global.metodos[nome_metodo]["poder"]
		var dano = objeto.forca * objeto.mforca * (poder / 2.0)
		dano = dano / (inimigo.defesa * inimigo.mdefesa / 2 + 1)
		inimigo.vida -= dano
		inimigo.vida = max(0.0, inimigo.vida)

		ui.turno = "inimigo"
		ui.messages.append("Você usou " + nome_metodo + "!")
		if dano != 0:
			ui.messages.append("Você deu %.1f de dano! Boa!" % dano)
		else:
			ui.messages.append("Você não deu dano! Nada boa!")

		if inimigo.vida == 0.0:
			var artigo = "o"
			if inimigo.pronomes == "ela/dela":
				artigo = "a"
			ui.messages.append("Você derrotou " + artigo + " " + inimigo.nome + "!")
			ui.connect("finished_text", end_battle)
	else:
		randomize()
		var i_metodo = randi_range(0, len(inimigo.metodos) - 1)
		nome_metodo = inimigo.metodos[i_metodo]

		var poder = global.metodos[nome_metodo]["poder"]
		var dano = inimigo.forca * inimigo.mforca * (poder / 2.0)
		dano = dano / (objeto.defesa * objeto.mdefesa / 2 + 1)
		global.player_health -= dano
		global.player_health = max(0.0, global.player_health)

		ui.turno = "player"
		ui.messages.append(inimigo.nome + " usou " + nome_metodo + "!")
		if dano != 0:
			ui.messages.append("Você recebeu %.1f de dano... Pena." % dano)
		else:
			ui.messages.append("Você não recebeu dano... Ok.")

		if global.player_health == 0:
			ui.messages.append("Você perdeu...")
			ui.connect("finished_text", end_battle)
	ui.show_message()

func end_battle():
	$FadeLayer.fade_out()
	await $FadeLayer/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/floresta_da_abstracao.tscn")
