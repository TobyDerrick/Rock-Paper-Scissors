class_name AudioButton extends Button

@export var pressed_audio: AudioStream = preload("res://AUDIO/SOUND EFFECTS/button_sound/GenericButton7.wav")
@export var hover_audio: AudioStream = preload("res://AUDIO/SOUND EFFECTS/button_sound/GenericButton6.wav")

func _ready():
	self.connect("mouse_entered", _on_mouse_entered)

func _pressed():
	SfxPlayer.play(pressed_audio)

func _on_mouse_entered():
	SfxPlayer.play(hover_audio)
