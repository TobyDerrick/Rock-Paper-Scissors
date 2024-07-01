extends CardState

func enter() -> void:
	if not card_ui.is_node_ready():
		await card_ui.ready
	
	card_ui.reparent_requested.emit(card_ui, "hand")
	card_ui.colour.color = Color.FOREST_GREEN
	card_ui.state.text = "BASE"
	card_ui.pivot_offset = Vector2.ZERO
	
func on_mouse_entered() -> void:
	if card_ui.is_playable:
		var tween = get_tree().create_tween()
		var target_pos = Vector2(card_ui.position.x, card_ui.base_position.y - 20)
		tween.tween_property(card_ui, "position", target_pos, 0.1)

func on_mouse_exited() -> void:
	if card_ui.is_playable:
		#handles edge case when calling mouse exited upon dropping card
		if not is_inside_tree():
			return
			
		var tween = get_tree().create_tween()
		var target_pos = Vector2(card_ui.position.x, card_ui.base_position.y)
		tween.tween_property(card_ui, "position", target_pos, 0.1)


func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		if card_ui.is_playable:
				card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
				transition_requested.emit(self, CardState.State.CLICKED)
