extends Control

const CHARACTER_SELECT = preload("res://SCENES/character_select.tscn")
func _ready():
	get_tree().paused = false

func _on_continue_pressed():
	pass # Replace with function body.


func _on_new_run_pressed():
	get_tree().change_scene_to_packed(CHARACTER_SELECT)


func _on_quit_pressed():
	get_tree().quit()
