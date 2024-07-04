extends Node
@onready var ovani_player = $OvaniPlayer

func play_song(song: OvaniSong) -> void:
	if not song:
		return
	if ovani_player.QueuedSongs.size() == 0:
		ovani_player.QueueSong(song)
		
	else:
		ovani_player.PlaySongNow(song)
		
func fade_intensity(intensity: float, trans_time: float) -> void:
	ovani_player.FadeIntensity(intensity, trans_time)
