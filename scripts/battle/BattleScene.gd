extends Node

var turno := "player"

func _ready():
	$FadeLayer.fade_in()

	$BattleUI.connect("battle_ended", _on_battle_ended)
	var objeto = global.objetos[global.objetos.keys()[0]]
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
	$EnemyMon.texture = load(global.enemy.sprites["64x64_front"])

	# É atualizado aqui o objeto do jogador, mas tbm deve ser atualizado o do inimigo

func _on_battle_ended():
	$FadeLayer.fade_out()
	await $FadeLayer/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/floresta_da_abstracao.tscn")
