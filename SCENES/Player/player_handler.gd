class_name PlayerHandler extends Node

const HAND_DRAW_INTERVAL:= 0.3

@export var hand: Hand
@export var draw_sound: AudioStream

var first_draw: bool = true
var character: CharacterStats

func _ready():
	Events.card_discarded.connect(add_card_to_discard_pile)

func start_battle(char_stats: CharacterStats) -> void:
	character = char_stats
	character.draw_pile = character.deck.duplicate(true)
	character.draw_pile.shuffle()
	character.discard = CardPile.new()
	if first_draw:
		draw_starting_hand(character.starting_cards)
		first_draw = false
	
	else:
		start_turn()

func start_turn(_prev_round_win_state: GlobalEnums.round_result = GlobalEnums.round_result.WIN) -> void:
	draw_cards(character.cards_per_turn)
	hand.enable_cards_in_hand()
	
func draw_card() -> void:
	reshuffle_deck_when_empty()
	SfxPlayer.play(draw_sound, false, true)
	hand.add_card(character.draw_pile.draw_card())
	reshuffle_deck_when_empty()

func draw_cards(amount: int) -> void:
	var tween:= create_tween()
	for i in range(amount):
		tween.tween_callback(draw_card)
		tween.tween_interval(HAND_DRAW_INTERVAL)
		
	tween.finished.connect(func(): Events.player_cards_drawn.emit())

func draw_starting_hand(amount: int) -> void:
	var tween:= create_tween()
	for i in range(amount):
		tween.tween_callback(draw_card)
		tween.tween_interval(HAND_DRAW_INTERVAL)
	
	tween.finished.connect(func(): Events.player_hand_drawn.emit())
	await tween.finished

func add_card_to_discard_pile(card: CardUI):
	character.discard.add_card(card.card)

func reshuffle_deck_when_empty():
	if not character.draw_pile.empty():
		return
	
	if character.discard.empty():
		print_debug("Discard pile is empty at same time as deck")
		
	while not character.discard.empty():
		character.draw_pile.add_card(character.discard.draw_card())
	
	character.draw_pile.shuffle()
