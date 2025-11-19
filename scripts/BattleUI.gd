extends Control

signal battle_ended

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

# Estados possíveis: "message", "actions", "fight"
var state: String = "message"

func _ready():
	update_status_boxes()
	# Conectar botões do menu principal
	btn_fight.pressed.connect(_on_fight)
	btn_bag.pressed.connect(_on_bag)
	btn_run.pressed.connect(_on_run)
	btn_party.pressed.connect(_on_party)

	# Conectar botões dos ataques
	attack1.pressed.connect(func(): _on_attack_pressed("Acelerar"))
	attack2.pressed.connect(func(): _on_attack_pressed("Dobrar"))
	attack3.pressed.connect(func(): _on_attack_pressed("Bola de Fogo"))
	attack4.pressed.connect(func(): _on_attack_pressed("Gelo Antigo"))

	# Conectar botão BACK
	back_btn.pressed.connect(_on_back)

	# Inicial
	fight_box.visible = false
	action_box.visible = false
	show_message("Um inimigo apareceu!")

#  SISTEMA DE MENSAGENS
func show_message(text: String):
	state = "message"
	fight_box.visible = false
	action_box.visible = false
	message_box.visible = true
	message_label.text = text


func show_actions():
	state = "actions"
	message_box.visible = false
	fight_box.visible = false
	action_box.visible = true


func show_fight():
	state = "fight"
	message_box.visible = false
	action_box.visible = false
	fight_box.visible = true

func _close_battle_ui():
	
	self.visible = false   # desativa TODO o BattleUI

	# Se quiser despausar o jogo quando acabar:
	# get_tree().paused = false

# Enter automaticamente sai das mensagens
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):

		if state == "message":
			show_actions()

		elif state == "victory":
			_close_battle_ui()

#  AÇÕES DOS BOTÕES DO MENU PRINCIPAL
func _on_fight():
	show_fight()

func _on_bag():
	show_message("Você abriu a mochila...")

func _on_run():
	show_message("Você tentou fugir!")

func _on_party():
	show_message("Você olhou sua equipe!")

#  AÇÕES DOS BOTÕES DE ATAQUE
func _on_attack_pressed(attack_name: String):
	damage_enemy(10)

	# se o inimigo morreu, NÃO mostrar outra mensagem
	if enemy_hp == 0:
		return

	show_message("Você usou %s!" % attack_name)



func _on_back():
	show_actions()

@onready var player_name = $PlayerStatusBox/LabelName
@onready var player_hp_label = $PlayerStatusBox/LabelHP
@onready var player_hp_bar = $PlayerStatusBox/ProgressBarHP

@onready var enemy_name = $EnemyStatusBox/LabelName
@onready var enemy_hp_label = $EnemyStatusBox/LabelHP
@onready var enemy_hp_bar = $EnemyStatusBox/ProgressBarHP


var player_max_hp = 100
var player_hp = 100
var player_xp = 0
var xp_reward = 25

var enemy_max_hp = 40
var enemy_hp = 40

func update_status_boxes():
	
	update_hp_color(player_hp_bar, player_hp, player_max_hp)
	update_hp_color(enemy_hp_bar, enemy_hp, enemy_max_hp)

	# Player
	player_name.text = "Marquinhos"
	player_hp_label.text = str(player_hp, " / ", player_max_hp)
	player_hp_bar.max_value = player_max_hp
	player_hp_bar.value = player_hp

	# Enemy
	enemy_name.text = "Amogus"
	enemy_hp_label.text = str(enemy_hp, " / ", enemy_max_hp)
	enemy_hp_bar.max_value = enemy_max_hp
	enemy_hp_bar.value = enemy_hp
	

func damage_enemy(amount: int):
	enemy_hp = max(0, enemy_hp - amount)
	update_status_boxes()

	print("Enemy HP:", enemy_hp)  # debug

	if enemy_hp == 0:
		print("Chamando end_battle")  # debug
		end_battle()

func damage_player(amount: int):
	player_hp = max(0, player_hp - amount)
	update_status_boxes()

func update_hp_color(pb: ProgressBar, hp: int, maxhp: int):
	var percent := float(hp) / float(maxhp)

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
