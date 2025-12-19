# move_button.gd
extends Button

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	var main := get_tree().current_scene

	var packed := load("res://scenes/IDE/ide.tscn") as PackedScene
	var ide := packed.instantiate()

	ide.previous_scene = main
	get_tree().get_root().add_child(ide)
	get_tree().current_scene = ide

	main.get_parent().remove_child(main)
