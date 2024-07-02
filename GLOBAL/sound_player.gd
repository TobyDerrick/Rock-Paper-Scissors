extends Node

func play(audio: AudioStream, single = false, randomize_pitch = false) -> void:
	if not audio:
		return
	
	if single:
		stop()
	
	for player in get_children():
		player = player as AudioStreamPlayer
		
		if not player.playing:
			if randomize_pitch:
				player.pitch_scale = randf_range(0.8, 1.2)
			
			else:
				player.pitch_scale = 1
			player.stream = audio
			player.play()
			break
			
func stop() -> void:
	for player in get_children():
		player = player as AudioStreamPlayer
		player.stop()
