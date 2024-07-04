class_name CardPopup extends Control

const CARD_MENU_UI = preload("res://SCENES/UI/card_menu_ui.tscn")

@onready var card_zone = %Card
@onready var card_desc = %CardDesc


func _ready():
	for card: CardMenuUI in card_zone.get_children():
		card.queue_free()
		
func show_popup(card: Card) -> void:
	var new_card := CARD_MENU_UI.instantiate() as CardMenuUI
	card_zone.add_child(new_card)
	new_card.card = card
	new_card.tooltip_requested.connect(hide_popup.unbind(1))
	card_desc.text = card.tooltip_text
	show()
	
func hide_popup() -> void:
	if not visible:
		return
	
	for card: CardMenuUI in card_zone.get_children():
		card.queue_free()
		
	hide()
func _on_gui_input(event):
	if event.is_action_pressed("left_mouse"):
		hide_popup()
