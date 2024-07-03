extends Control

func _on_button_pressed():
	Events.rest_exited.emit()
