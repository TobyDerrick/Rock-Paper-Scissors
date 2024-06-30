class_name EnemyBrain extends Node

const PLACE_CARD_INTERVAL:= 0.25

var character: CharacterStats
var enemy_hand: Hand
var cards_used: int

func _ready():
	Events.enemy_cards_drawn.connect(_handle_enemy_hand_drawn)

func perform_turn():
	
	var tween:= create_tween()
	
	cards_used = 0
	for cardUI: CardUI in enemy_hand.get_children():
		tween.tween_callback(add_card_to_stack.bind(cardUI))
		tween.tween_interval(PLACE_CARD_INTERVAL)
		
	await tween.finished
	end_turn()
	
func add_card_to_stack(cardUI: CardUI):
		if cards_used < character.max_cards_in_stack:
			cardUI.card_state_machine.current_state.transition_requested.emit(cardUI.card_state_machine.current_state, CardState.State.RELEASED)
			cardUI.reparent_requested.emit(cardUI, "enemy_card_stack")
			cards_used += 1
	

func _handle_enemy_hand_drawn():
	perform_turn()

func end_turn() -> void:
	Events.enemy_turn_ended.emit()

