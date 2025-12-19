extends Node2D

var c = Compiler.new()
var classes = []
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
	code = """public class System {
	Out out = new Out();
}
"""
	var classe = c.parse_code(code)
	if classe.classe == "Exception":
		classe.print_message()
		return
	classes.append(classe)
	print("Classe System:")
	print(classe.repr())

	code = """public class Out {
	String println(String x) {
		return x;
	}

	int println(int x) {
		return x;
	}
}
"""
	classe = c.parse_code(code)
	if classe.classe == "Exception":
		classe.print_message()
		return
	classes.append(classe)
	print("Classe Out:")
	print(classe.repr())

	code = """public class Pedra {
	int tamanho = 1;

	int jogar(int x) {
		return x * 2;
	}

	void aumentar() {
		this.tamanho = this.tamanho + 1;
	}

	int bater(int x) {
		return x * this.tamanho;
	}
}
"""
	classe = c.parse_code(code)
	if classe.classe == "Exception":
		classe.print_message()
		return
	classes.append(classe)
	print("Classe Pedra:")
	print(classe.repr())

	code = """public class Main {
	public static void main() {
		Pedra p = new Pedra();

		System.out.println(p.jogar(3));

		p.aumentar();
		p.aumentar();

		System.out.println(p.tamanho);
	}
}
"""
	classe = c.parse_code(code)
	if classe.classe == "Exception":
		classe.print_message()
		return
	classe.sout.connect(println)
	classes.append(classe)
	print("Classe Main:")
	print(classe.repr())

	var nome_metodo
	var parametros
	var resultado

	nome_metodo = StringJDT.new("main")
	parametros = ArrayJDT.new([])
	resultado = classe.chamar_metodo(nome_metodo, parametros, ArrayJDT.new(classes))
	if resultado.classe == "Exception":
		resultado.print_message()
		return
	print("main(): ", resultado.repr())

	#nome_metodo = StringJDT.new("somar")
	#parametros = ArrayJDT.new([IntJDT.new(23), IntJDT.new(12)])
	#resultado = classe.chamar_metodo(nome_metodo, parametros)
	#if resultado.classe == "Exception":
	#	resultado.print_message()
	#	return
	#print("somar(23, 12): ", resultado.value)

	#nome_metodo = StringJDT.new("greet")
	#parametros = ArrayJDT.new([StringJDT.new("Jonas")])
	#resultado = classe.chamar_metodo(nome_metodo, parametros)
	#if resultado.classe == "Exception":
	#	resultado.print_message()
	#	return
	#print("greet(\"Jonas\"): ", resultado.value)

	#nome_metodo = StringJDT.new("testar")
	#parametros = ArrayJDT.new([IntJDT.new(13)])
	#resultado = classe.chamar_metodo(nome_metodo, parametros)
	#if resultado.classe == "Exception":
	#	resultado.print_message()
	#	return
	#print("testar(13): ", resultado.value)

	#nome_metodo = StringJDT.new("testar")
	#parametros = ArrayJDT.new([IntJDT.new(13)])
	#resultado = classe.chamar_metodo(nome_metodo, parametros)
	#if resultado.classe == "Exception":
	#	resultado.print_message()
	#	return
	#print("testar(13): ", resultado.value)

	#nome_metodo = StringJDT.new("testar")
	#parametros = ArrayJDT.new([IntJDT.new(15)])
	#resultado = classe.chamar_metodo(nome_metodo, parametros)
	#if resultado.classe == "Exception":
	#	resultado.print_message()
	#	return
	#print("testar(15): ", resultado.value)

func println(message: String) -> void:
	print(message)
