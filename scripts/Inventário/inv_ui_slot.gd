extends Panel

class_name DragSlot

@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display

# Variáveis para o slot
var slot_index: int = -1
var is_red_slot: bool = false  
var slot_data: InvSlot

func _ready():
	# Permite input do mouse
	mouse_filter = Control.MOUSE_FILTER_PASS
	is_red_slot = false 
	
func setup(index: int):
	slot_index = index
	is_red_slot = false

# Função chamada quando o mouse é pressionado no slot
func _get_drag_data(at_position: Vector2):
	# Só permite arrastar se o slot tem um item
	if slot_data and slot_data.item:
		print("Iniciando arraste do slot ", slot_index, " (", "vermelho" if is_red_slot else "normal", ")")
		
		# Cria um preview visual que segue o mouse
		var preview = Control.new()
		preview.size = Vector2(32, 32)
		
		var sprite = Sprite2D.new()
		sprite.texture = slot_data.item.texture
		sprite.centered = true
		sprite.position = Vector2(16, 16)
		preview.add_child(sprite)
		
		set_drag_preview(preview)
		
		# Retorna os dados que serão usados no drop
		return {
			"origin_slot_index": slot_index,
			"origin_is_red": is_red_slot,
			"item": slot_data.item,
			"texture": slot_data.item.texture
		}
	
	return null

# Função chamada para verificar se pode soltar aqui
func _can_drop_data(at_position: Vector2, data):
	# Aceita qualquer drop que venha de outro slot
	return data is Dictionary and data.has("origin_slot_index")

# Função chamada quando solta o item aqui
func _drop_data(at_position: Vector2, data):
	print("Soltando no slot ", slot_index, " (", "vermelho" if is_red_slot else "normal", ")")
	
	# Pega a referência da UI do inventário
	var inv_ui = get_parent().get_parent().get_parent() as Control
	
	if inv_ui and inv_ui.has_method("process_drag_drop"):
		inv_ui.process_drag_drop(
			data["origin_slot_index"],  # Índice do slot de origem
			data["origin_is_red"],      # Se origem é vermelho
			slot_index,                 # Índice do slot de destino
			is_red_slot                 # Se destino é vermelho
		)

func update(slot: InvSlot):
	slot_data = slot
	if !slot.item:
		item_visual.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
