extends Control

func _ready():
	MusicPlayer.fade_intensity(0.5, 1)

func _on_button_pressed():
	Events.battle_rewards_exited.emit()
