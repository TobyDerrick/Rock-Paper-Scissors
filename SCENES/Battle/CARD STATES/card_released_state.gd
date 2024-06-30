extends CardState

var played: bool

func enter() -> void:
	card_ui.colour.color = Color.HOT_PINK
	card_ui.state.text = "RELEASED"
	
	played = false
	card_ui.pivot_offset = card_ui.size / 2
	if not card_ui.targets.is_empty():
		card_ui.reparent_requested.emit(card_ui, "stack")
		played = true
		
func on_input(_event: InputEvent) -> void:
	if played:
		return
	
	transition_requested.emit(self, CardState.State.BASE)
