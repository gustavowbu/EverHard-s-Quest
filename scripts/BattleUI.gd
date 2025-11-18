extends Control

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


# Enter automaticamente sai das mensagens
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		if state == "message":
			show_actions()

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
	show_message("Você usou " + attack_name + "!")


func _on_back():
	show_actions()
