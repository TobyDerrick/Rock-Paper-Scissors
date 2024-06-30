class_name EnemyHandler extends PlayerHandler

@onready var enemy_brain: EnemyBrain = $EnemyBrain as EnemyBrain

func start_battle(char_stats: CharacterStats) -> void:
	character = char_stats
	character.draw_pile = character.deck.duplicate(true)
	character.draw_pile.shuffle()
	character.discard = CardPile.new()
	
	enemy_brain.character = character
	enemy_brain.enemy_hand = hand
	draw_starting_hand(character.starting_cards)
	
func start_turn(_previous_round_result: GlobalEnums.round_result = GlobalEnums.round_result.WIN) -> void:
	draw_cards(character.cards_per_turn)

func draw_cards(amount: int) -> void:
	var tween:= create_tween()
	for i in range(amount):
		tween.tween_callback(draw_card)
		tween.tween_interval(HAND_DRAW_INTERVAL)
		
	tween.finished.connect(func(): Events.enemy_cards_drawn.emit())

func draw_starting_hand(amount: int) -> void:
	var tween:= create_tween()
	for i in range(amount):
		tween.tween_callback(draw_card)
		tween.tween_interval(HAND_DRAW_INTERVAL)
	
	tween.finished.connect(func(): Events.enemy_hand_drawn.emit())
