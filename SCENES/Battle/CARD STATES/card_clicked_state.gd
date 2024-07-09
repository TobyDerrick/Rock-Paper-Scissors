extends CardState

func enter() -> void:
	card_ui.pivot_offset = card_ui.size / 2
	card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset
	# could implement velocity based rotation here in future
	card_ui.card_visuals.card_sprite.material.set_shader_parameter("x_rot", 0)
	card_ui.card_visuals.card_sprite.material.set_shader_parameter("y_rot", 0)
	
	card_ui.rotation = 0
	card_ui.drop_point_detector.monitoring = true
	
func on_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		transition_requested.emit(self, CardState.State.DRAGGING)
