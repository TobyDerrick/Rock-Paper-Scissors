class_name CardRewards extends ColorRect

signal card_reward_selected(card: Card)

const CARD_MENU_UI = preload("res://SCENES/UI/card_menu_ui.tscn")

@export var rewards: Array[Card] : set = set_rewards

@onready var cards = %Cards
@onready var skip_card_reward = %SkipCardReward
@onready var card_popup = $CardPopup
@onready var take_card_button = %TakeCardButton

var selected_card: Card

func _ready():
	_clear_rewards()
	
	take_card_button.pressed.connect(
		func():
			card_reward_selected.emit(selected_card)
			queue_free()
	)
	
	skip_card_reward.pressed.connect(
		func():
			card_reward_selected.emit(null)
			queue_free()
	)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		card_popup.hide_popup()
		
func _clear_rewards() -> void:
	for card: Node in cards.get_children():
		card.queue_free()
	
	card_popup.hide_popup()
	selected_card = null

func _show_popup(card: Card) -> void:
	selected_card = card
	card_popup.show_popup(card)
	
func set_rewards(value: Array[Card]) -> void:
	rewards = value
	
	if not is_node_ready():
		await ready
	
	_clear_rewards()
	for card: Card in rewards:
		var new_card := CARD_MENU_UI.instantiate() as CardMenuUI
		cards.add_child(new_card)
		new_card.card = card
		new_card.tooltip_requested.connect(_show_popup)
