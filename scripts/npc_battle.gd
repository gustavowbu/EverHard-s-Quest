extends Area2D

func start_battle():
	BattleManager.battle_data = {
		"enemy_name": "monitor everhard",
		"enemy_mon": "polimorfismo",
		"enemy_hp": 30
	}
	get_tree().change_scene_to_file("res://scenes/Battle/battleScene.tscn")
