extends Control

signal attack(nome_metodo)

@onready var message_box = $MessageBox
@onready var message_label = $MessageBox/Label

@onready var action_box = $ActionsBox
@onready var btn_fight = $ActionsBox/VBoxContainer/ButtonFight
@onready var btn_bag = $ActionsBox/VBoxContainer/ButtonBag
@onready var btn_run = $ActionsBox/VBoxContainer/ButtonRun
@onready var btn_party = $ActionsBox/VBoxContainer/ButtonParty

@onready var fight_box = $BoxPanel   # NOVO MENU
@onready var attack1 = $BoxPanel/FightBox/Attack1
@onready var attack2 = $BoxPanel/FightBox/Attack2
@onready var attack3 = $BoxPanel/FightBox/Attack3
@onready var attack4 = $BoxPanel/FightBox/Attack4
@onready var back_btn = $BoxPanel/VBox/BackButton

var inimigo = global.enemy
var turno = "player"

# Estados possíveis: "message", "actions", "fight", "victory"
var state := "message"
var messages := []

func _ready():
	update_status_boxes()
	# Conectar botões do menu principal
	btn_fight.pressed.connect(_on_fight)
	btn_bag.pressed.connect(_on_bag)
	btn_run.pressed.connect(_on_run)
	btn_party.pressed.connect(_on_party)

	var objeto = global.objetos[global.objetos.keys()[0]]
	var metodos = objeto.metodos
	# Conectar botões dos ataques
	if len(metodos) >= 1:
		attack1.pressed.connect(func(): _on_attack_pressed(metodos[0]))
	if len(metodos) >= 2:
		attack2.pressed.connect(func(): _on_attack_pressed(metodos[1]))
	if len(metodos) >= 3:
		attack3.pressed.connect(func(): _on_attack_pressed(metodos[2]))
	if len(metodos) >= 4:
		attack4.pressed.connect(func(): _on_attack_pressed(metodos[3]))

	# Conectar botão BACK
	back_btn.pressed.connect(_on_back)

	# Inicial
	fight_box.visible = false
	action_box.visible = false

	var artigo = "Um"
	if global.enemy.pronomes == "ela/dela":
		artigo += "a"
	messages.append(artigo + " " + global.enemy.nome + " selvagem apareceu!")
	show_message()

#  SISTEMA DE MENSAGENS
func show_message():
	state = "message"
	fight_box.visible = false
	action_box.visible = false
	message_box.visible = true
	message_label.text = messages[0]

func show_actions():
	state = "actions"
	fight_box.visible = false
	action_box.visible = true
	message_box.visible = true
	message_label.text = ""

func show_fight():
	state = "fight"
	fight_box.visible = true
	action_box.visible = false
	message_box.visible = true
	message_label.text = ""

func _close_battle_ui():
	self.visible = false   # desativa TODO o BattleUI

	# Se quiser despausar o jogo quando acabar:
	# get_tree().paused = false

# Enter automaticamente sai das mensagens
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		if state == "message":
			if len(messages) > 1:
				messages.pop_at(0)
				show_message()
			elif len(messages) == 1:
				messages.pop_at(0)
				update_status_boxes()
				if turno == "player":
					show_actions()
				else:
					emit_signal("attack", "")

		elif state == "victory":
			_close_battle_ui()

#  AÇÕES DOS BOTÕES DO MENU PRINCIPAL
func _on_fight():
	show_fight()

func _on_bag():
	messages.append("Você abriu a mochila...")
	show_message()

func _on_run():
	messages.append("Você tentou fugir!")
	show_message()

func _on_party():
	messages.append("Você olhou sua equipe!")
	show_message()

#  AÇÕES DOS BOTÕES DE ATAQUE
func _on_attack_pressed(attack_name: String):
	emit_signal("attack", attack_name)



func _on_back():
	show_actions()

@onready var player_name = $PlayerStatusBox/LabelName
@onready var player_hp_label = $PlayerStatusBox/LabelHP
@onready var player_hp_bar = $PlayerStatusBox/ProgressBarHP

@onready var enemy_name = $EnemyStatusBox/LabelName
@onready var enemy_hp_label = $EnemyStatusBox/LabelHP
@onready var enemy_hp_bar = $EnemyStatusBox/ProgressBarHP


var player_max_hp = 100.0
var player_hp = global.player_health
var xp_reward = 25

var enemy_max_hp = 40
var enemy_hp = 40

func update_status_boxes():
	update_hp_color(player_hp_bar, global.player_health, global.player_health_max)
	update_hp_color(enemy_hp_bar, inimigo.vida, inimigo.vida_max)

	# Player
	player_name.text = "Apolo"
	player_hp_label.text = str(global.player_health, " / ", global.player_health_max)
	player_hp_bar.max_value = global.player_health_max
	player_hp_bar.value = global.player_health

	# Enemy
	enemy_name.text = inimigo.nome
	enemy_hp_label.text = str(inimigo.vida, " / ", inimigo.vida_max)
	enemy_hp_bar.max_value = inimigo.vida_max
	enemy_hp_bar.value = inimigo.vida

func update_hp_color(pb: ProgressBar, hp: float, maxhp: float):
	var percent := hp / maxhp

	var color: Color

	if percent > 0.5:
		color = Color(0.0, 0.8, 0.0) # verde
	elif percent > 0.2:
		color = Color(1.0, 0.7, 0.0) # amarelo
	else:
		color = Color(1.0, 0.2, 0.2) # vermelho

	var fill_style := StyleBoxFlat.new()
	fill_style.bg_color = color

	# ProgressBar correto: usa "fill"
	pb.add_theme_stylebox_override("fill", fill_style)


func end_battle():
	state = "victory"

	# Esconde tudo da batalha
	message_box.visible = true
	action_box.visible = false
	fight_box.visible = false

	message_label.text = "Você derrotou o inimigo!\nGanhou %d XP!" % xp_reward

	# Espera o jogador ver a mensagem
	await get_tree().create_timer(1.5).timeout

	emit_signal("battle_ended")
