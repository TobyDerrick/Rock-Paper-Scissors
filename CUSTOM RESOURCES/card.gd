class_name Card extends Resource

enum Type {ROCK, PAPER, SCISSORS}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var strong_to: Array[Type]
@export var weak_to: Array[Type]

@export_group("Visuals")
@export var card_sprite: Texture
