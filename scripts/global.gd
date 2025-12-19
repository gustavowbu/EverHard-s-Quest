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
var player_health_max := 100.0
var player_health := 100.0
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
	objetos["Pedra"] = Pedra.new()
	objetos["Pedra"].metodos = ["jogar", "aumentar"]
	objetos["Pedra"].codigo = codigo_pedra

func atualizar_objetos_selecionados() -> void:
	objetos_selecionados = []
	for tab in tabs:
		if not tab in ["Main", "Objeto vazio"]:
			objetos_selecionados.append(tab)
	print("Objetos selecionados atualizados: ", objetos_selecionados)
	

var current_scene = "res://scenes/main.tscn"

var metodos = {
	"jogar": {"tipo": "ataque", "poder": 10.0},
	"aumentar": {"tipo": "status", "poder": 0.0},
	"rastejar": {"tipo": "status", "poder": 0.0},
	"veneno": {"tipo": "ataque", "poder": 5.0},
	"enrolar": {"tipo": "ataque", "poder": 15.0}
}

func objeto_disponivel(nome_objeto: String) -> bool:
	return nome_objeto in objetos_selecionados

# Função para obter o código de um objeto
func obter_codigo_objeto(nome_objeto: String) -> String:
	if nome_objeto in objetos:
		return objetos[nome_objeto].codigo
	return ""
