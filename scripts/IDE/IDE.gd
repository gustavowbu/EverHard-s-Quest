extends CanvasLayer

@onready var editor = $"Text Area/CodeEdit"
var compiler = Compiler.new()

func _ready() -> void:
	editor.grab_focus()

func _on_run_button_button_down() -> void:
	var code: String = editor.text
	var classe = compiler.parse_code(code)
	if not is_error(classe):
		print(classe.chamar_metodo("somar", [2, 3]))

func is_error(valor) -> bool:
	if typeof(valor) != 24:
		return false
	return valor.get_classe() == "Erro"
