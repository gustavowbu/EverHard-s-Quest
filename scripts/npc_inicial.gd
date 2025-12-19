extends Area2D

@export var raio_interacao: float = 70.0
@onready var player = get_node("../jogador")

@onready var label_interacao: Label = $LabelInteracao
@onready var caixa_dialogo: Label = $CanvasLayer/CaixaDialogo
@onready var texto_dialogo: Label = $CanvasLayer/TextoDialogo


var jogador_in_area = false
var falando = false
var pode_avancar = false
var fala_index = 0

var falas = [
	"Everhard: Finalmente… alguém conseguiu chegar até aqui.",
	"Apolo: Quem é você?",
	"Everhard: Meu nome é Everhard.",
	"Everhard: Eu era o guardião dos Pilares de POO.",
	"Everhard: Abstração, Encapsulamento, Herança, Polimorfismo…",
	"Apolo: Era?",
	"Everhard: Eu falhei.",
	"Everhard: Os pilares se perderam.",
	"Everhard: Sem um deles, não consigo ir atrás dos outros.",
	"Apolo: E o que isso tem a ver comigo?",
	"Everhard: Tudo."
]

func _ready():
	caixa_dialogo.visible = false
	texto_dialogo.visible = false
	label_interacao.visible = false

func _process(_delta):
	verificar_distancia()

	if jogador_in_area and not falando and Input.is_action_just_pressed("interact"):
		iniciar_dialogo()

func verificar_distancia():
	var distancia = global_position.distance_to(player.global_position)

	if distancia <= raio_interacao:
		jogador_in_area = true
		label_interacao.visible = true
	else:
		jogador_in_area = false
		label_interacao.visible = false
		if falando:
			encerrar_dialogo()

func iniciar_dialogo():
	falando = true
	player.pode_mover = false   # 🔒 TRAVA JOGADOR

	label_interacao.visible = false
	caixa_dialogo.visible = true
	texto_dialogo.visible = true
	fala_index = 0
	proxima_fala()

func proxima_fala():
	if fala_index < falas.size():
		pode_avancar = false
		texto_dialogo.text = ""
		mostrar_texto_com_efeito(falas[fala_index])
		fala_index += 1
	else:
		encerrar_dialogo()

func mostrar_texto_com_efeito(texto):
	for letra in texto:
		texto_dialogo.text += letra
		await get_tree().create_timer(0.02).timeout

	pode_avancar = true
	await get_tree().create_timer(1.2).timeout

	if falando:
		proxima_fala()

func encerrar_dialogo():
	falando = false
	pode_avancar = false
	player.pode_mover = true   # ✅ LIBERA JOGADOR

	texto_dialogo.visible = false
	caixa_dialogo.visible = false
