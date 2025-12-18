extends CharacterBody2D

const speed = 300

var direction := "down"
var state := "run"
@onready var interact_area = $InteractArea
@export var inv: Inv
@export var selectedObjects: Inv 
@onready var animation = $AnimatedSprite2D

func _ready():
	$FadeLayer.fade_in()
	if global.player_position != Vector2.ZERO:
		global_position = global.player_position
		print("POSIÇÃO RESTAURADA:", global_position)
	
	# Isso é um debug pq o inv vermelho está com problema
	print("Inventário principal carregado:", inv != null)
	print("Inventário selecionado carregado:", selectedObjects != null)
	if selectedObjects != null:
		print("Slots no inventário selecionado:", selectedObjects.slots.size())
		for i in range(selectedObjects.slots.size()):
			print("Slot", i, ":", "Vazio" if selectedObjects.slots[i].item == null else selectedObjects.slots[i].item.name)

func _process(_delta): # Deixa o _ só enquanto o parâmetro não é usado. Quando for utilizar, remove o _
	if Input.is_action_just_pressed("ide"):
		var main := get_tree().current_scene

		var packed := load("res://scenes/IDE/ide.tscn") as PackedScene
		var ide := packed.instantiate()

		ide.previous_scene = main
		get_tree().get_root().add_child(ide)
		get_tree().current_scene = ide

		main.get_parent().remove_child(main)
	if Input.is_action_just_pressed("DEBUG"):
		print(global.objetos)

func _physics_process(delta):
	player_movement(delta)

func player_movement(_delta): # Deixa o _ só enquanto o parâmetro não é usado. Quando for utilizar, remove o _
	var right = bool_to_int(Input.is_action_pressed("right"))
	var left = bool_to_int(Input.is_action_pressed("left"))
	var down = bool_to_int(Input.is_action_pressed("down"))
	var up = bool_to_int(Input.is_action_pressed("up"))
	var x_movement = right - left
	var y_movement = down - up
	velocity.x = speed * x_movement
	velocity.y = speed * y_movement

	if x_movement != 0:
		state = "run"
		if right:
			direction = "right"
		else:
			direction = "left"
	elif y_movement != 0:
		state = "run"
		if up:
			direction = "up"
		if down:
			direction = "down"
	else:
		state = "idle"

	move_and_slide()

	var animation_name := state + "_" + direction
	animation.play(animation_name)

func bool_to_int(boolean: bool) -> int:
	return 1 if boolean else 0

func _input(event):
	if event.is_action_pressed("interact"):
		var bodies = interact_area.get_overlapping_bodies()
		for b in bodies:
			if b.is_in_group("npc"):
				b.start_battle()

func player() -> void:
	pass

func collect(item):
	inv.insert(item)
	
func select_item(item: InvItem):
	if selectedObjects == null:
		print("ERRO CRÍTICO: selectedObjects é NULO!")
		return
	print("=== ADICIONANDO AO INVENTÁRIO SELECIONADO ===")
	print("Item:", item.name)
	print("Textura do item:", item.texture != null)
	
	# Verifica slots antes de inserir
	var empty_slots = selectedObjects.slots.filter(func(slot): return slot.item == null)
	print("Slots vazios no inventário selecionado:", empty_slots.size())
	
	# Chama insert
	selectedObjects.insert(item)
	
	# Verifica após inserir
	print("Após inserir - Slots:")
	for i in range(selectedObjects.slots.size()):
		var slot = selectedObjects.slots[i]
		if slot.item:
			print("Slot", i, ":", slot.item.name, "Quantidade:", slot.amount)
		
		else:
			print("Slot", i, ": Vazio")
		print("==============================")
