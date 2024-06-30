class_name RoundResults extends VBoxContainer

func update_round_checkbox(round_result: GlobalEnums.round_result) -> void:
	
	if round_result == GlobalEnums.round_result.DRAW:
		return
	
	for checkbox: RoundCheckBox in get_children():
		if not checkbox.checked:
			checkbox.set_sprite(round_result)
			checkbox.checked = true
			break
