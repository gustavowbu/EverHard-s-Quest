extends CharacterBody2D

const speed = 300

var current_dir = "none"
@onready var interact_area = $InteractArea
@export var inv: Inv

func _physics_process(delta):
	player_movement(delta)

func _input(event):
	if event.is_action_pressed("interact"):
		var bodies = interact_area.get_overlapping_bodies()
		for b in bodies:
			if b.is_in_group("npc"):
				b.start_battle()
	elif event.is_action_pressed("ide1"):
		print("Abrindo Objeto 1...")

func player_movement(delta):
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
			

func player():
	pass
