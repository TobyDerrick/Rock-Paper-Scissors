extends Control

func _on_button_pressed():
	Events.special_event_exited.emit()
