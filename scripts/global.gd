extends Node

var tabs := ["Main", "Pedra", "Objeto vazio", "Objeto vazio", "Objeto vazio"]
var objetos_selecionados = ["Pedra"]
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

var player_position := Vector2.ZERO
var enemy = null
var enemy_name = ""
var enemies_defeated = []

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

func atualizar_objetos_selecionados() -> void:
	objetos_selecionados = []
	for tab in tabs:
		if not tab in ["Main", "Objeto vazio"]:
			objetos_selecionados.append(tab)

var current_scene = "res://scenes/main.tscn"
