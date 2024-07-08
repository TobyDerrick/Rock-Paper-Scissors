extends Node
@onready var ovani_player = $OvaniPlayer

func play_song(song: OvaniSong) -> void:
	if not song:
		return
	if ovani_player.QueuedSongs.size() == 0:
		ovani_player.QueueSong(song)
		
	else:
		print()
		ovani_player.PlaySongNow(song, 0)
		
func fade_intensity(intensity: float, trans_time: float) -> void:
	ovani_player.FadeIntensity(intensity, trans_time)
