class_name BattleUI extends CanvasLayer

@export var char_stats: CharacterStats : set = _set_char_stats
@export var enemy_stats: CharacterStats :  set =  _set_enemy_stats
@export var end_turn_sound: AudioStream

@onready var hand: Hand = $PlayerHand
@onready var enemy_hand = $EnemyHand
@onready var card_stack: CardStack = $CardStack
@onready var enemy_card_stack: CardStack =  $EnemyCardStack
@onready var end_turn_button: Button = %EndTurn
@onready var round_results = $RoundResults
@onready var end_game_panel = $EndGamePanel
@onready var rich_text_label = $EndGamePanel/RichTextLabel

func _ready():
	Events.player_cards_drawn.connect(_on_player_cards_drawn)
	Events.finished_comparing_stacks.connect(_on_finished_comparing_cards)
	Events.battle_completed.connect(_handle_battle_completed)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)
	

func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	card_stack.char_stats = char_stats
	card_stack.update_card_stack_ui()
	hand.char_stats = char_stats
	

func _set_enemy_stats(value: CharacterStats) -> void:
	enemy_stats = value
	enemy_card_stack.char_stats = enemy_stats
	enemy_card_stack.update_card_stack_ui()
	enemy_hand.char_stats =  enemy_stats
	
func _on_player_cards_drawn() -> void:
	end_turn_button.disabled = false

func _on_end_turn_button_pressed() -> void:
	hand.disable_cards_in_hand()
	SfxPlayer.play(end_turn_sound)
	end_turn_button.disabled = true
	Events.player_turn_ended.emit()

func _on_finished_comparing_cards(round_result: GlobalEnums.round_result) -> void:
	round_results.update_round_checkbox(round_result)

func _handle_battle_completed(battle_result: GlobalEnums.round_result) -> void:
	if battle_result == GlobalEnums.round_result.WIN:
		rich_text_label.text = "[center][wave amp=20.0 freq=8.0 connected=1][rainbow freq=1.0 sat=0.8 val=1.0]You Win![/rainbow] [/wave] [/center]"
	elif battle_result == GlobalEnums.round_result.LOSE:
		rich_text_label.text = "[center][wave amp=20.0 freq=8.0 connected=1][rainbow freq=1.0 sat=0.8 val=1.0]You Lose![/rainbow] [/wave] [/center]"
	end_turn_button.visible = false
	hand.disable_cards_in_hand()
	rich_text_label.visible = true
	end_game_panel.visible = true
