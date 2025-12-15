extends Node

var tabs := [
	{"nome": "Main", "codigo": ""},
	{"nome": "Pedra", "codigo": ""},
	{"nome": "Objeto vazio", "codigo": ""},
	{"nome": "Objeto vazio", "codigo": ""},
	{"nome": "Objeto vazio", "codigo": ""},
]
var objetos := [Objeto.new(), Objeto.new(), Objeto.new(), Objeto.new()]
var player_position: Vector2 = Vector2.ZERO
var inimigo_derrotado: String = ""

func _ready() -> void:
	var codigo_pedra = """public class Pedra {
	int tamanho = 1;

	int jogar(int x) {
		return x * 2;
	}

	int aumentar() {
		this.tamanho = this.tamanho + 1;
	}
}
"""
	tabs[1]["codigo"] = codigo_pedra
	objetos[0] = Pedra.new(
		["jogar", "aumentar"]
	)

var current_scene = "res://scenes/main.tscn"
