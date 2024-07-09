class_name SceneTransition extends CanvasLayer

@onready var animation_player = $ScreenTransition/AnimationPlayer

func play_transition() -> void:
	animation_player.play("circle_fade")
	await animation_player.animation_finished
	Events.trans_out_complete.emit()
	animation_player.play("circle_wipe")
