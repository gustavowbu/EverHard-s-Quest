extends Node

func _ready():
	$FadeLayer.fade_in()

	$battle_ui.connect("battle_ended", _on_battle_ended)
	var objeto = global.objetos[global.objetos.keys()[0]]
	var metodos = objeto.metodos
	if len(metodos) >= 1:
		$battle_ui/BoxPanel/FightBox/Attack1.text = metodos[0]
	if len(metodos) >= 2:
		$battle_ui/BoxPanel/FightBox/Attack2.text = metodos[1]
	if len(metodos) >= 3:
		$battle_ui/BoxPanel/FightBox/Attack3.text = metodos[2]
	if len(metodos) >= 4:
		$battle_ui/BoxPanel/FightBox/Attack4.text = metodos[3]

	$Objeto.texture = load(objeto.sprites["64x64_back"])

	# É atualizado aqui o objeto do jogador, mas tbm deve ser atualizado o do inimigo

func _on_battle_ended():
	$FadeLayer.fade_out()
	await $FadeLayer/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/floresta_da_abstracao.tscn")
