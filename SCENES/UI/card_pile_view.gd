class_name CardPileView extends Control

const CARD_MENU_UI = preload("res://SCENES/UI/card_menu_ui.tscn")

@export var card_pile: CardPile

@onready var pile_title: Label = %PileTitle
@onready var cards: GridContainer = %Cards
@onready var back_button: Button = %BackButton
@onready var card_popup: CardPopup = %CardPopup

func _ready():
	Events.show_card_pile.connect(show_current_view)
	back_button.pressed.connect(hide)
	
	#remove any cards in grid on startup
	for card: Node in cards.get_children():
		card.queue_free()

	card_popup.hide_popup()
	hide()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if card_popup.visible:
			card_popup.hide_popup()
		
		else:
			hide()

func show_current_view(cards_to_show: CardPile, new_title: String, randomized: bool = false) -> void:
	for card: Node in cards.get_children():
		card.queue_free()
	
	card_pile = cards_to_show
	card_popup.hide_popup()
	pile_title.text = new_title
	_update_view.call_deferred(randomized)
	
func _update_view(randomized: bool) -> void:
	if not card_pile:
		return
		
	var all_cards := card_pile.cards.duplicate()
	if randomized:
		all_cards.shuffle()
	
	for card: Card in all_cards:
		var new_card := CARD_MENU_UI.instantiate() as CardMenuUI
		cards.add_child(new_card)
		new_card.card = card
		new_card.tooltip_requested.connect(card_popup.show_popup)
		
	show()
