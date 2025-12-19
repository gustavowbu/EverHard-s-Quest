# move_button.gd
extends Button

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	print("Botão mover pressionado")
	
	# Pega a referência da UI do inventário
	var inv_ui = get_parent().get_parent()  # Ajuste conforme sua hierarquia
	
	if inv_ui.has_method("move_selected_to_red"):
		inv_ui.move_selected_to_red()
