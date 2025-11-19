extends Control

@onready var anim = $AnimationPlayer

func fade_in():
	anim.play("fade_in")

func fade_out():
	anim.play("fade_out")
