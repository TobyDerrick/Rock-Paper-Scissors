class_name CardComparisonHandler extends Node

const COMPARISON_INTERVAL := 0.5

@export var player_card_stack: CardStack
@export var enemy_card_stack: CardStack

@onready var battle_ui: BattleUI = $"../BattleUI" as BattleUI

enum hand_comparison_results{WIN, LOSE, DRAW}
var comparison_score: int

func _ready():
	Events.enemy_turn_ended.connect(_handle_enemy_turn_ended)
	
func _handle_enemy_turn_ended():
	handle_comparison()

func handle_comparison():
	comparison_score = 0
	
	while not player_card_stack.card_stack.is_empty() or not enemy_card_stack.card_stack.is_empty():
		compare_next_card()
		await get_tree().create_timer(COMPARISON_INTERVAL).timeout
	#all cards compared
	
	Events.finished_comparing_stacks.emit(determine_winner())
	
func compare_next_card():
	
		var player_top_card: CardUI
		var enemy_top_card: CardUI
		
		if not player_card_stack.card_stack.is_empty():
			player_top_card = player_card_stack.card_stack.front()
		
		if not enemy_card_stack.card_stack.is_empty():
			enemy_top_card = enemy_card_stack.card_stack.front()
		
		match compare_cards(player_top_card, enemy_top_card):
			hand_comparison_results.WIN:
				comparison_score += 1
			
			hand_comparison_results.LOSE:
				comparison_score -= 1
			
			hand_comparison_results.DRAW:
				pass
		
		player_card_stack.discard_top_card_from_stack()
		enemy_card_stack.discard_top_card_from_stack()

func compare_cards(card1, card2) -> hand_comparison_results:
	if card1 == null and card2 != null:
		#lose
		return hand_comparison_results.LOSE
	elif card1 != null and card2 == null:
		#win
		return hand_comparison_results.WIN
	
	if card1.card.type in card2.card.weak_to:
		#win
		return hand_comparison_results.WIN
	
	elif card1.card.type in card2.card.strong_to:
		#lose
		return hand_comparison_results.LOSE
	
	else:
		#draw
		return hand_comparison_results.DRAW

func determine_winner() -> GlobalEnums.round_result:
	if comparison_score < 0:
		return GlobalEnums.round_result.LOSE
	
	elif comparison_score > 0 :
		return GlobalEnums.round_result.WIN
	
	else:
		return GlobalEnums.round_result.DRAW
	
