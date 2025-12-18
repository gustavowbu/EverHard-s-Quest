extends Node

var tabs := ["Main", "Pedra", "Objeto vazio", "Objeto vazio", "Objeto vazio"]
var objetos := {}
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

var player_position: Vector2 = Vector2.ZERO
var inimigo_derrotado: String = ""

func _ready() -> void:
	var codigo_pedra = """public class Pedra {
	int tamanho = 1;

	int jogar(int x) {
		return x * 2;
	}

	void aumentar() {
		this.tamanho = this.tamanho + 1;
	}
}
"""
	objetos["Pedra"] = Pedra.new(["jogar", "aumentar"], codigo_pedra)

var current_scene = "res://scenes/main.tscn"
