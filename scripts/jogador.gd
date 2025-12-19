extends CharacterBody2D

const speed = 300

var direction := "down"
var state := "run"
var pode_mover := true   # 🔒 CONTROLE DE MOVIMENTO

@onready var interact_area = $InteractArea
@export var inv: Inv
@export var selectedObjects: Inv 
@onready var animation = $AnimatedSprite2D

func _ready():
	$FadeLayer.fade_in()
	if global.player_position != Vector2.ZERO:
		global_position = global.player_position

func _process(_delta):
	if Input.is_action_just_pressed("ide"):
		var main := get_tree().current_scene
		var packed := load("res://scenes/IDE/ide.tscn") as PackedScene
		var ide := packed.instantiate()
		ide.previous_scene = main
		get_tree().get_root().add_child(ide)
		get_tree().current_scene = ide
		main.get_parent().remove_child(main)

func _physics_process(delta):
	player_movement(delta)

func player_movement(_delta):
	# 🚫 BLOQUEIA MOVIMENTO DURANTE DIÁLOGO
	if not pode_mover:
		velocity = Vector2.ZERO
		move_and_slide()
		animation.play("idle_" + direction)
		return

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
		direction = "right" if right else "left"
	elif y_movement != 0:
		state = "run"
		direction = "up" if up else "down"
	else:
		state = "idle"

	move_and_slide()
	animation.play(state + "_" + direction)

func bool_to_int(boolean: bool) -> int:
	return 1 if boolean else 0
