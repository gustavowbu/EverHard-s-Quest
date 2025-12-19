extends CharacterBody2D
class_name Objeto

@export var velocidade: float = 50.0
@export var mover_no_eixo_x: bool = true
@export var mover_no_eixo_y: bool = false

@export var distancia_max: float = 60.0
@export var raio_acao: float = 90.0

@export var caminho_cena_batalha: String = "res://scenes/Battle/BattleScene.tscn"

@onready var player = get_node("../jogador")

var direcao := 1
var pos_inicial: Vector2

func _ready():
	add_to_group("enemies")
	pos_inicial = global_position

func _process(delta) -> void:
	mover(delta)
	verificar_distancia_para_player()

func mover(delta) -> void:
	var movimento := Vector2.ZERO

	if mover_no_eixo_x:
		movimento.x = direcao * velocidade * delta

	if mover_no_eixo_y:
		movimento.y = direcao * velocidade * delta

	global_position += movimento

	if global_position.distance_to(pos_inicial) >= distancia_max:
		direcao *= -1

func verificar_distancia_para_player() -> void:
	if player == null:
		print("Player é NULL! Verifique o caminho do nó.")
		return

	var distancia = global_position.distance_to(player.global_position)

	if distancia <= raio_acao:
		entrar_batalha()

func entrar_batalha():
	global.player_position = player.global_position
	global.enemy = copy()
	global.enemy_name = self.name
	global.enemies_defeated.append(get_path())

	print("O inimigo detectou o player! Indo para batalha...")
	get_tree().change_scene_to_file(caminho_cena_batalha)

# Informações do objeto

var nome := "Objeto nulo"
var pronomes := "ele/dele"
@export var metodos := []
var codigo := ""

var vida_max := 50.0
var vida := 50.0
var forca := 10.0
var defesa := 10.0
var mvida := 1.0
var mforca := 1.0
var mdefesa := 1.0

var atributos := {}
var testes := {}

var sprites = {
	"16x16": null,
	"32x32_front": null,
	"32x32_back": null,
	"64x64_front": null,
	"64x64_back": null
}

func copy() -> Objeto:
	var copia = get_script().new()

	copia.velocidade = velocidade
	copia.mover_no_eixo_x = mover_no_eixo_x
	copia.mover_no_eixo_y = mover_no_eixo_y
	copia.distancia_max = distancia_max
	copia.raio_acao = raio_acao
	copia.caminho_cena_batalha = caminho_cena_batalha
	copia.player = player

	copia.direcao = direcao
	copia.pos_inicial = pos_inicial

	copia.nome = nome
	copia.metodos = metodos
	copia.codigo = codigo

	copia.vida = vida
	copia.forca = forca
	copia.defesa = defesa
	copia.mvida = mvida
	copia.mforca = mforca
	copia.mdefesa = mdefesa

	copia.atributos = atributos
	copia.testes = testes

	return copia
