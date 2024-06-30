class_name BattleUI extends CanvasLayer

@export var char_stats: CharacterStats : set = _set_char_stats
@export var enemy_stats: CharacterStats :  set =  _set_enemy_stats

@onready var hand: Hand = $PlayerHand as Hand
@onready var enemy_hand = $EnemyHand as Hand
@onready var card_stack: CardStack = $CardStack as CardStack
@onready var enemy_card_stack: CardStack =  $EnemyCardStack as CardStack
@onready var end_turn_button: Button = %EndTurn

func _ready():
	Events.player_cards_drawn.connect(_on_player_cards_drawn)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)
	

func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	card_stack.char_stats = char_stats
	hand.char_stats = char_stats

func _set_enemy_stats(value: CharacterStats) -> void:
	enemy_stats = value
	enemy_card_stack.char_stats = enemy_stats
	enemy_hand.char_stats =  enemy_stats
	
func _on_player_cards_drawn() -> void:
	end_turn_button.disabled = false

func _on_end_turn_button_pressed() -> void:
	end_turn_button.disabled = true
	Events.player_turn_ended.emit()
