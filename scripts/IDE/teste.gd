extends Node2D

var code = """
public class Teste {
	int x = 13;

	int somar(int x, int y) {
		return x + y;
	}

	String greet(String nome) {
		String resultado = "Olá, " + nome;
		return resultado;
	}

	boolean testar(int x) {
		boolean result = this.x == x;
		this.x = this.x + 1;
		return result;
	}
}
"""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var c = Compiler.new()
	var classe = c.parse_code(code)

	if classe.classe == "Exception":
		classe.print_message()
		return

	print("Classe:\n", classe.repr())
	print()

	var nome_metodo
	var parametros
	var resultado

	nome_metodo = StringJDT.new("somar")
	parametros = ArrayJDT.new([IntJDT.new(23), IntJDT.new(12)])
	resultado = classe.chamar_metodo(nome_metodo, parametros)
	if resultado.classe == "Exception":
		resultado.print_message()
		return
	print("somar(23, 12): ", resultado.value)

	nome_metodo = StringJDT.new("greet")
	parametros = ArrayJDT.new([StringJDT.new("Jonas")])
	resultado = classe.chamar_metodo(nome_metodo, parametros)
	if resultado.classe == "Exception":
		resultado.print_message()
		return
	print("greet(\"Jonas\"): ", resultado.value)

	nome_metodo = StringJDT.new("testar")
	parametros = ArrayJDT.new([IntJDT.new(13)])
	resultado = classe.chamar_metodo(nome_metodo, parametros)
	if resultado.classe == "Exception":
		resultado.print_message()
		return
	print("testar(13): ", resultado.value)

	nome_metodo = StringJDT.new("testar")
	parametros = ArrayJDT.new([IntJDT.new(13)])
	resultado = classe.chamar_metodo(nome_metodo, parametros)
	if resultado.classe == "Exception":
		resultado.print_message()
		return
	print("testar(13): ", resultado.value)

	nome_metodo = StringJDT.new("testar")
	parametros = ArrayJDT.new([IntJDT.new(15)])
	resultado = classe.chamar_metodo(nome_metodo, parametros)
	if resultado.classe == "Exception":
		resultado.print_message()
		return
	print("testar(15): ", resultado.value)
