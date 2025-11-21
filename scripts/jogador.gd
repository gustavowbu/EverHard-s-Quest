extends CharacterBody2D

const speed = 300

var current_dir = "none"
@onready var interact_area = $InteractArea
@export var inv: Inv

func _ready():
	if global.player_position != Vector2.ZERO:
		global_position = global.player_position
		print("POSIÇÃO RESTAURADA:", global_position)


func _process(_delta): # Deixa o _ só enquanto o parâmetro não é usado. Quando for utilizar, remove o _
	for i in range(4):
		if Input.is_action_just_pressed("ide" + str(i + 1)):
			var main := get_tree().current_scene

			var packed := load("res://scenes/IDE/ide.tscn") as PackedScene
			var ide := packed.instantiate()

			ide.previous_scene = main
			get_tree().get_root().add_child(ide)
			get_tree().current_scene = ide

			main.get_parent().remove_child(main)
			ide.alterar_codigo(i)
			ide.update()
	if Input.is_action_just_pressed("ide5"):
		print(global.objetos)

func _physics_process(delta):
	player_movement(delta)

func player_movement(_delta): # Deixa o _ só enquanto o parâmetro não é usado. Quando for utilizar, remove o _
	if Input.is_action_pressed("right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("down"):
		current_dir = "down"
		play_anim(1)
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("up"):
		current_dir = "up"
		play_anim(1)
		velocity.y = -speed
		velocity.x = 0
	else:
		play_anim(0)
		velocity.y = 0
		velocity.x = 0

	move_and_slide()

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D2

	if dir == "right":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")

		elif movement == 0:
			anim.play("side_idle")

	if dir == "left":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			anim.play("front_idle")
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			anim.play("back_idle")

func _input(event):
	if event.is_action_pressed("interact"):
		var bodies = interact_area.get_overlapping_bodies()
		for b in bodies:
			if b.is_in_group("npc"):
				b.start_battle()

func player() -> void:
	pass
