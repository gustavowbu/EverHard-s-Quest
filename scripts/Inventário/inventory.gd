extends Resource

class_name Inv

signal update
signal items_changed
@export var slots: Array[InvSlot]

func insert(item: InvItem):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].amount+=1
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
	update.emit()
	items_changed.emit()

func get_item_names() -> Array[String]:
	var names: Array[String] = []
	for slot in slots:
		if slot.item:
			names.append(slot.item.name)
		else:
			names.append("Objeto vazio")
	return names
