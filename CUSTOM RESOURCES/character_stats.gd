class_name CharacterStats extends Stats

@export var starting_deck: CardPile
@export var card_back_sprite: Texture
@export var starting_cards: int
@export var cards_per_turn: int
@export var max_cards_in_stack: int


var deck: CardPile
var discard: CardPile
var draw_pile: CardPile

func create_instance() -> Resource:
	var instance: CharacterStats = self.duplicate()
	instance.deck = instance.starting_deck.duplicate()
	instance.draw_pile = CardPile.new()
	instance.discard = CardPile.new()
	return instance

