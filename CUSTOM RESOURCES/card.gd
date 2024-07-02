class_name Card extends Resource

enum Type {ROCK, PAPER, SCISSORS}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var strong_to: Array[Type]
@export var weak_to: Array[Type]

@export_group("Visuals")
@export var card_top_sprite: Texture

@export_group("Audio")
@export var play_sound: AudioStream = preload("res://AUDIO/SOUND EFFECTS/cardSlide2.ogg")
@export var card_hover_sound: AudioStream = preload("res://AUDIO/SOUND EFFECTS/cardSlide5.ogg")
@export var card_flip_sound: AudioStream = preload("res://AUDIO/SOUND EFFECTS/cardPlace1.ogg")
