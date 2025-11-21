extends Node

func _ready():
	$FadeLayer.fade_in()

	$battle_ui.connect("battle_ended", Callable(self, "_on_battle_ended"))
	var metodos = global.objetos[0]["metodos"]
	if len(metodos) > 0:
		$battle_ui/BoxPanel/FightBox/Attack1.text = global.objetos[0]["metodos"][0]
	if len(metodos) > 1:
		$battle_ui/BoxPanel/FightBox/Attack2.text = global.objetos[0]["metodos"][1]
	if len(metodos) > 2:
		$battle_ui/BoxPanel/FightBox/Attack3.text = global.objetos[0]["metodos"][2]
	if len(metodos) > 3:
		$battle_ui/BoxPanel/FightBox/Attack4.text = global.objetos[0]["metodos"][3]

	if global.objetos[0]["nome"] == "Pedra":
		$Objeto.texture = load("res://sprites/Objetos/pedra-costas.png")
	elif global.objetos[0]["nome"] == "Zumbi":
		$Objeto.texture = load("res://sprites/Objetos/zumbi-costas.png")

func _on_battle_ended():
	print("Batalha terminou!")

	$FadeLayer.fade_out()

	await $FadeLayer/AnimationPlayer.animation_finished

	get_tree().change_scene_to_file("res://scenes/ForestLevel.tscn")
