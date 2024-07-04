class_name CardStack extends Node2D

@export var char_stats: CharacterStats
@export var stack_id: String
@export var card_counter: Label

var card_stack: Array[CardUI]
var cards_in_stack: int = 0

func _on_card_ui_reparent_requested(card_ui: CardUI, target_pos: String) -> void: 
	if(target_pos == stack_id):
		add_card_to_stack(card_ui)

func add_card_to_stack(card_ui: CardUI) -> void:
	if cards_in_stack < char_stats.max_cards_in_stack:
		SfxPlayer.play(card_ui.card.play_sound, false, true)
		card_ui.reparent(self)
		card_ui.rotation = randf_range(deg_to_rad(-20), deg_to_rad(20))
		card_ui.global_position = global_position
		card_stack.push_front(card_ui)
		cards_in_stack = card_stack.size()
		card_counter.text = str(cards_in_stack) + " / " + str(char_stats.max_cards_in_stack)
	
	else:
		card_ui.card_state_machine.current_state.transition_requested.emit(card_ui.card_state_machine.current_state,
																		   CardState.State.BASE)

func discard_top_card_from_stack() -> void:
	if card_stack.size() > 0:
		var top_card: CardUI = card_stack.front()
		Events.card_discarded.emit(top_card, stack_id)
		top_card.queue_free()
		card_stack.pop_front()
		cards_in_stack = card_stack.size()
		card_counter.text = str(cards_in_stack) + " / " + str(char_stats.max_cards_in_stack)		

func remove_top_card_from_stack() -> void:
	if cards_in_stack > 0:
		var top_card: CardUI = card_stack[0]
		top_card.card_state_machine.current_state.transition_requested.emit(top_card.card_state_machine.current_state,
																			   CardState.State.BASE)
		card_stack.pop_front()
		cards_in_stack = card_stack.size()
		update_card_stack_ui()

func update_card_stack_ui() -> void:
	card_counter.text = str(cards_in_stack) + " / " + str(char_stats.max_cards_in_stack)

	

func clear_stack():
	card_stack.clear()

func _on_button_pressed():
	remove_top_card_from_stack()
	
func _on_player_hand_card_added_to_hand(card):
	card.reparent_requested.connect(_on_card_ui_reparent_requested)

func _on_enemy_hand_card_added_to_hand(card):
	card.reparent_requested.connect(_on_card_ui_reparent_requested)
