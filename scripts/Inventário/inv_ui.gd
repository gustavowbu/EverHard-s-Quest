extends Control

@onready var inv: Inv = preload("res://scenes/Inventário/inventory/Inventario.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var selectedObjects: Inv = preload("res://scenes/Inventário/inventory/selectedObjects.tres")
@onready var red_slots: Array = $NinePatchRect/GridContainer2.get_children()

var is_open = false

func _ready():
	inv.update.connect(update_slots)
	selectedObjects.update.connect(update_slots)
	update_slots()
	close()

func update_slots():
	for i in range(min(inv.slots.size(),slots.size())):
		slots[i].update(inv.slots[i])
	for i in range(min(selectedObjects.slots.size(),red_slots.size())):
		red_slots[i].update(selectedObjects.slots[i])

func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		if is_open:
			close()
		else:
			open()

func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false # pode ser false se der erro
	
