extends Control

const DIEGO_STATS = preload("res://CHARACTERS/Diego/diego_stats.tres")
const ISAAC_STATS = preload("res://CHARACTERS/Isaac/isaac_stats.tres")
const SUZIE_STATS = preload("res://CHARACTERS/Suzie/suzie_stats.tres")

@onready var character_name = %CharacterName
@onready var description = %Description
@onready var character_sprite = %Character_Sprite

var current_character: CharacterStats : set = _set_current_character

func _ready():
	_set_current_character(DIEGO_STATS)
	
func _set_current_character(new_character: CharacterStats) -> void:
	current_character = new_character
	character_name.text = current_character.character_name
	description.text = current_character.description
	character_sprite.sprite_frames = current_character.portrait_spriteframes

func _on_start_button_pressed():
	pass # Replace with function body.

func _on_diego_button_pressed():
	current_character = DIEGO_STATS


func _on_isaac_button_pressed():
	current_character = ISAAC_STATS


func _on_suzie_button_pressed():
	current_character =  SUZIE_STATS
