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
	var codigo_main = """public class Main {
	public static void main() {
		Pedra p = new Pedra();

		System.out.println(p.jogar(3));

		p.aumentar();
		p.aumentar();

		System.out.println(p.tamanho);
	}
}
"""
	tabs[0]["codigo"] = codigo_main

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
