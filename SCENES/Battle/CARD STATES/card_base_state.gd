extends CardState

var card_hoverable: bool = true


func enter() -> void:
	if not card_ui.is_node_ready():
		await card_ui.ready
	
	card_ui.reparent_requested.emit(card_ui, "hand")
	card_ui.pivot_offset = Vector2.ZERO
	
func on_mouse_entered() -> void:
	if not card_hoverable:
		return
	if card_ui.is_playable:
		SfxPlayer.play(card_ui.card.card_hover_sound, true)
		var tween = create_tween()
		tween.tween_property(card_ui, "global_position", Vector2.UP * 20, 0.1).as_relative()

func on_mouse_exited() -> void:
	if card_ui.is_playable:
		if not is_inside_tree():
			return
		card_hoverable = false
		var tween = create_tween()
		var target_pos = Vector2(card_ui.base_position.x, card_ui.base_position.y)
		tween.tween_property(card_ui, "position", target_pos, 0.1)
		await tween.finished
		card_hoverable = true
		card_ui.card_visuals.card_sprite.material.set_shader_parameter("x_rot", 0)
		card_ui.card_visuals.card_sprite.material.set_shader_parameter("y_rot", 0)


func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		if card_ui.is_playable:
				card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
				transition_requested.emit(self, CardState.State.CLICKED)

	if event is InputEventMouseMotion:
		if not card_ui.is_playable:
			return
			
		var hand: Hand = card_ui.get_parent()
		var mouse_pos: Vector2 = card_ui.get_local_mouse_position()
		#var diff: Vector2 = (card_ui.position + card_ui.size) - mouse_pos
		
		var lerp_val_x: float = remap(mouse_pos.x, 0.0, card_ui.size.x, 0,1)
		var lerp_val_y: float = remap(mouse_pos.y, 0.0, card_ui.size.y, 0,1)
		
		var rot_x: float = rad_to_deg(lerp_angle(-card_ui.angle_x_max, card_ui.angle_x_max, lerp_val_x))
		var rot_y: float = rad_to_deg(lerp_angle(card_ui.angle_y_max, -card_ui.angle_y_max, lerp_val_y))
		
		card_ui.card_visuals.card_sprite.material.set_shader_parameter("x_rot", rot_y)
		card_ui.card_visuals.card_sprite.material.set_shader_parameter("y_rot", rot_x)
