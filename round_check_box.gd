class_name RoundCheckBox extends Panel

var checked: bool = false
@onready var tick = $Tick
@onready var cross = $Cross

func set_sprite(round_result: GlobalEnums.round_result) -> void:
	match round_result:
		GlobalEnums.round_result.WIN:
			tick.visible = true
		GlobalEnums.round_result.LOSE:
			cross.visible = true
