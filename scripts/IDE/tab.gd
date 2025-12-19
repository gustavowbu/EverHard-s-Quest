extends Button

@export var text_label = "Página 1"
var is_open := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_text(text_label)

func update_text(new_text: String) -> void:
	$Label.text = new_text

func open() -> void:
	$Sprite2D.texture = load("res://sprites/tab_focus.png")
	is_open = true

func close() -> void:
	$Sprite2D.texture = load("res://sprites/tab.png")
	is_open = false

func toggle() -> void:
	if is_open:
		close()
	else:
		open()

func _on_button_down() -> void:
	toggle()
