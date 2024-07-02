extends CardState

func enter() -> void:
	# could implement velocity based rotation here in future
	card_ui.card_sprite.material.set_shader_parameter("x_rot", 0)
	card_ui.card_sprite.material.set_shader_parameter("y_rot", 0)
	
	card_ui.rotation = 0

	card_ui.colour.color = Color.ORANGE
	card_ui.state.text = "CLICKED"
	card_ui.drop_point_detector.monitoring = true
	
func on_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		transition_requested.emit(self, CardState.State.DRAGGING)
