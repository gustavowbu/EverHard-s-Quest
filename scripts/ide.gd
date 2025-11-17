extends CanvasLayer

@onready var code_edit = $"Text Area/CodeEdit"

func _ready() -> void:
	code_edit.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
