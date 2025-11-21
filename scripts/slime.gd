# Slime.gd
extends "res://scripts/inimigo.gd"
class_name Slime

func _ready():
	super._ready() # chama o ready do inimigo.gd
	$AnimatedSprite2D.play("walk")
	
var testes = {
	
}

@export var vida: int = 40
@export var forca: int = 3
@export var multiplicador_ataque: float = 1.0
