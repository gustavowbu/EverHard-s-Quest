extends Node

func _ready():
	$FadeLayer.fade_in()

	$battle_ui.connect("battle_ended", Callable(self, "_on_battle_ended"))

func _on_battle_ended():
	print("Batalha terminou!")

	$FadeLayer.fade_out()

	await $FadeLayer/AnimationPlayer.animation_finished

	get_tree().change_scene_to_file("res://scenes/ForestLevel.tscn")
