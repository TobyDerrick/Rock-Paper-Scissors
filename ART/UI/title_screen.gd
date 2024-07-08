extends Control

@export var main_song: OvaniSong

const CHARACTER_SELECT = preload("res://SCENES/character_select.tscn")
func _ready():
	MusicPlayer.play_song(main_song)
	#MusicPlayer.fade_intensity(0, 1)
	
	get_tree().paused = false

func _on_continue_pressed():
	pass # Replace with function body.


func _on_new_run_pressed():
	get_tree().change_scene_to_packed(CHARACTER_SELECT)


func _on_quit_pressed():
	get_tree().quit()
