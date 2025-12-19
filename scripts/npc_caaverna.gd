extends Area2D

@export var raio_interacao: float = 70.0  # como no inimigo
@onready var player = get_node("../jogador")

@onready var label_interacao: Label = $LabelInteracao
@onready var caixa_dialogo: Label = $CanvasLayer/CaixaDialogo
@onready var texto_dialogo: Label = $CanvasLayer/TextoDialogo

var jogador_in_area = false
var falando = false


var pode_avancar = false
var fala_index = 0

var falas = [
	"NPC: Ei! Veja isso aqui…",
	"Apolo: …Não tem nada aí.",
	"NPC: Claro que tem.",
	"NPC: Mas você não consegue ver.",
	"NPC: Esqueci que isso é um atributo privado.",
	"Apolo: Então ele existe, mas fica escondido?",
	"NPC: Exatamente.",
	"NPC: Em Java, dados importantes ficam dentro da classe.",
	"NPC: Protegidos do acesso direto.",
	"NPC: Quem está fora não pode mexer do jeito que quiser.",
	"NPC: Acesso só acontece por métodos públicos.",
	"NPC: Isso se chama encapsulamento.",
	"NPC: Menos bagunça. Menos erro."
]

func _ready() -> void:
	caixa_dialogo.visible = false
	texto_dialogo.visible = false
	label_interacao.visible = false


func _process(_delta):
	verificar_distancia()

	# Jogador inicia o diálogo
	if jogador_in_area and not falando and Input.is_action_just_pressed("interact"):
		iniciar_dialogo()


# -------------------------------------------------
# DETECTA DISTÂNCIA ENTRE JOGADOR E NPC
# -------------------------------------------------
func verificar_distancia() -> void:
	if player == null:
		return

	var distancia = global_position.distance_to(player.global_position)

	if distancia <= raio_interacao:
		if not jogador_in_area:
			jogador_in_area = true
			label_interacao.text = "Pressione 'E' para conversar"
			label_interacao.visible = true
	else:
		if jogador_in_area:
			jogador_in_area = false
			label_interacao.visible = false

			if falando:
				encerrar_dialogo()


# -------------------------------------------------
# DIÁLOGO
# -------------------------------------------------

func iniciar_dialogo():
	falando = true
	player.pode_mover = false   # 🔒 NOVO

	label_interacao.visible = false
	caixa_dialogo.visible = true
	texto_dialogo.visible = true
	fala_index = 0
	proxima_fala()



func proxima_fala():
	if fala_index < falas.size():
		pode_avancar = false
		texto_dialogo.text = ""
		var texto = falas[fala_index]
		fala_index += 1
		mostrar_texto_com_efeito(texto)
	else:
		encerrar_dialogo()


func mostrar_texto_com_efeito(texto: String) -> void:
	await get_tree().create_timer(0.1).timeout
	
	for letra in texto:
		texto_dialogo.text += letra 
		await get_tree().create_timer(0.02).timeout

	pode_avancar = true

	await get_tree().create_timer(1.2).timeout

	if falando and pode_avancar:
		proxima_fala()


func encerrar_dialogo():
	falando = false
	pode_avancar = false
	player.pode_mover = true   # ✅ NOVO

	texto_dialogo.visible = false
	caixa_dialogo.visible = false
