extends CharacterBody2D

@export var velocidade: float = 100.0
@export var mover_no_eixo_x: bool = true
@export var mover_no_eixo_y: bool = false

@export var distancia_max: float = 60.0
@export var raio_acao: float = 15.0

@export var caminho_cena_batalha: String = "res://scenes/Battle/battleScene.tscn"

@onready var player = get_node("../jogador")

var direcao: int = 1
var pos_inicial: Vector2


func _ready():
	pos_inicial = global_position


func _process(delta):
	mover_inimigo(delta)
	verificar_distancia_para_player()



func mover_inimigo(delta):	
	var movimento := Vector2.ZERO

	if mover_no_eixo_x:
		movimento.x = direcao * velocidade * delta

	if mover_no_eixo_y:
		movimento.y = direcao * velocidade * delta

	global_position += movimento

	
	if global_position.distance_to(pos_inicial) >= distancia_max:
		direcao *= -1



func verificar_distancia_para_player():
	if player == null:
		print("❌ Player é NULL! Verifique o caminho do nó.")
		return

	var distancia = global_position.distance_to(player.global_position)

	if distancia <= raio_acao:
		entrar_batalha()



func entrar_batalha():
	print("🎯 O inimigo detectou o player! Indo para batalha...")
	get_tree().change_scene_to_file(caminho_cena_batalha)
