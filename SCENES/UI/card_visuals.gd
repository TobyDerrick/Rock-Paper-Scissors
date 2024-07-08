class_name CardVisuals extends Control

@export var card: Card : set = set_card

@onready var card_sprite = $CardSprite
@onready var foil_rarity_temp = $FoilRarityTEMP
@onready var card_flip = $CardFlip

var card_top_sprite: Texture
var card_bottom_sprite: Texture
var card_current_sprite: Texture

func set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	
	card = value
	card_sprite.texture = card.card_top_sprite
	
	foil_rarity_temp.text = str(Card.Rarity.find_key(card.rarity))
	
func swap_faces():
	if card_current_sprite == card_bottom_sprite:
		card_sprite.texture = card.card_top_sprite
	
	elif card_current_sprite == card_top_sprite:
		card_sprite.texture = card_bottom_sprite
	
	card_current_sprite = card_sprite.texture

