extends Node

var codigos := ["", "", "", ""]
var objetos := [{"nome": "", "metodos": []}, {"nome": "", "metodos": []}, {"nome": "", "metodos": []}, {"nome": "", "metodos": []}]

func _ready() -> void:
	codigos[0] = """public class Pedra {
	int tamanho = 1;

	int jogar(int x) {
		return x * 2;
	}

	int aumentar() {
		this.tamanho = this.tamanho + 1;
	}
}
"""

var current_scene = "res://scenes/main.tscn"
