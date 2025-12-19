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
	"NPC: Agora observe algo importante.",
	"NPC: Posso guardar um Guerreiro ou um Mago",
	"NPC: em uma variável do tipo Personagem.",
	"Apolo: Mesmo eles sendo classes diferentes?",
	"NPC: Sim.",
	"NPC: Porque ambos são Personagem.",
	"NPC: A variável enxerga o tipo da superclasse.",
	"NPC: Mas o objeto real continua sendo o que ele é.",
	"NPC: Quando atacar() é chamado…",
	"NPC: Java executa o método da classe real do objeto.",
	"NPC: Isso permite código genérico.",
	"NPC: Código reutilizável.",
	"NPC: Código flexível.",
	"NPC: Esse é o poder do polimorfismo."


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
