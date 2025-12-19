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
	
	setup_slots()
	
	sync_selected_to_global()

func setup_slots():
	for i in range(slots.size()):
		if slots[i] is DragSlot:  # Verifica se é do tipo correto
			slots[i].setup(i)  # Passa apenas o índice
	
	# Configura slots vermelhos  
	for i in range(red_slots.size()):
		if red_slots[i] is DragSlotRed:  
			red_slots[i].setup(i) 
			

func _on_selected_items_changed():
	# Chamado quando os itens selecionados mudam
	print("Itens selecionados mudaram! Sincronizando com global...")
	sync_selected_to_global()

func sync_selected_to_global():
	# Obtém os nomes dos itens dos slots vermelhos
	var item_names = selectedObjects.get_item_names()
	
	# Atualiza o array tabs do global
	update_global_tabs(item_names)

func update_global_tabs(item_names: Array[String]):
	# O array tabs deve ter: ["Main"] + [4 itens dos slots vermelhos]
	var new_tabs = ["Main"]
	
	# Adiciona os 4 itens (ou "Objeto vazio" se não tiver item)
	for i in range(4):  # Sempre 4 slots
		if i < item_names.size():
			new_tabs.append(item_names[i])
		else:
			new_tabs.append("Objeto vazio")
	
	# Atualiza o global
	global.tabs = new_tabs
	
	# Atualiza a lista de objetos selecionados
	global.atualizar_objetos_selecionados()
	
	print("Global.tabs atualizado: ", global.tabs)
	print("Objetos selecionados: ", global.objetos_selecionados)

func process_drag_drop(from_index: int, from_is_red: bool, to_index: int, to_is_red: bool):
	print("Processando drag & drop:")
	print("  De: slot ", from_index, " (", "vermelho" if from_is_red else "normal", ")")
	print("  Para: slot ", to_index, " (", "vermelho" if to_is_red else "normal", ")")
	
	# Se for o mesmo slot, não faz nada
	if from_index == to_index and from_is_red == to_is_red:
		print("  Mesmo slot, ignorando...")
		return
	
	# Decide qual ação tomar baseado nos tipos de slots
	if not from_is_red and not to_is_red:
		# Normal → Normal (troca dentro do inventário principal)
		swap_main_slots(from_index, to_index)
		
	elif not from_is_red and to_is_red:
		# Normal → Vermelho (move para inventário selecionado)
		move_to_red_slot(from_index, to_index)
		
	elif from_is_red and not to_is_red:
		# Vermelho → Normal (devolve ao inventário principal)
		move_to_main_slot(from_index, to_index)
		
	else:
		# Vermelho → Vermelho (troca dentro do inventário selecionado)
		swap_red_slots(from_index, to_index)
	if from_is_red or to_is_red:
		sync_selected_to_global()
		


func move_to_red_slot(main_index: int, red_index: int):
	if main_index >= inv.slots.size() or red_index >= selectedObjects.slots.size():
		return
	
	var main_slot = inv.slots[main_index]
	var red_slot = selectedObjects.slots[red_index]
	
	if main_slot.item == null:
		print("Erro: Slot principal vazio")
		return
	
	# Se slot vermelho está vazio, move o item
	if red_slot.item == null:
		red_slot.item = main_slot.item
		red_slot.amount = 1
		
		main_slot.amount -= 1
		if main_slot.amount <= 0:
			main_slot.item = null
	else:
		# Se já tem item, troca
		swap_between_inventories(main_index, red_index)
	
	# Atualiza ambos inventários
	inv.update.emit()
	selectedObjects.update.emit()

func move_to_main_slot(red_index: int, main_index: int):
	if red_index >= selectedObjects.slots.size() or main_index >= inv.slots.size():
		return
	
	var red_slot = selectedObjects.slots[red_index]
	var main_slot = inv.slots[main_index]
	
	if red_slot.item == null:
		print("Erro: Slot vermelho vazio")
		return
	
	if main_slot.item == null:
		main_slot.item = red_slot.item
		main_slot.amount = red_slot.amount
		
		red_slot.item = null
		red_slot.amount = 0
	else:
		swap_between_inventories(main_index, red_index, false)
	
	inv.update.emit()
	selectedObjects.update.emit()

func swap_between_inventories(main_index: int, red_index: int, from_main_to_red: bool = true):
	var main_slot = inv.slots[main_index]
	var red_slot = selectedObjects.slots[red_index]
	
	# Troca os itens
	var temp_item = main_slot.item
	var temp_amount = main_slot.amount
	
	main_slot.item = red_slot.item
	main_slot.amount = red_slot.amount
	
	red_slot.item = temp_item
	red_slot.amount = temp_amount

func swap_main_slots(index1: int, index2: int):
	if index1 >= inv.slots.size() or index2 >= inv.slots.size():
		return
	
	var slot1 = inv.slots[index1]
	var slot2 = inv.slots[index2]
	
	# Troca os itens
	var temp_item = slot1.item
	var temp_amount = slot1.amount
	
	slot1.item = slot2.item
	slot1.amount = slot2.amount
	
	slot2.item = temp_item
	slot2.amount = temp_amount
	
	inv.update.emit()

func swap_red_slots(index1: int, index2: int):
	if index1 >= selectedObjects.slots.size() or index2 >= selectedObjects.slots.size():
		return
	
	var slot1 = selectedObjects.slots[index1]
	var slot2 = selectedObjects.slots[index2]
	
	# Troca os itens
	var temp_item = slot1.item
	var temp_amount = slot1.amount
	
	slot1.item = slot2.item
	slot1.amount = slot2.amount
	
	slot2.item = temp_item
	slot2.amount = temp_amount
	
	selectedObjects.update.emit()

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])
	
	for i in range(min(selectedObjects.slots.size(), red_slots.size())):
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
	update_slots()

func close():
	visible = false
	is_open = false
