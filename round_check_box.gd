class_name RoundCheckBox extends Panel

var checked: bool = false
@onready var color_rect = $ColorRect

func set_sprite(round_result: GlobalEnums.round_result) -> void:
	match round_result:
		GlobalEnums.round_result.WIN:
			color_rect.color = Color.GREEN
		GlobalEnums.round_result.LOSE:
			color_rect.color = Color.RED
