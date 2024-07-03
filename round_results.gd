class_name RoundResults extends VBoxContainer


const ROUND_CHECK_BOX = preload("res://round_check_box.tscn")

func instantiate_round_check_boxes(number_to_spawn: int) -> void:
	for number in number_to_spawn:
		var this_box := ROUND_CHECK_BOX.instantiate()
		add_child(this_box)
		
func update_round_checkbox(round_result: GlobalEnums.round_result) -> void:
	
	if round_result == GlobalEnums.round_result.DRAW:
		return
	
	for checkbox: RoundCheckBox in get_children():
		if not checkbox.checked:
			checkbox.set_sprite(round_result)
			checkbox.checked = true
			break
