class_name BattleUI extends CanvasLayer

@export var char_stats: CharacterStats : set = _set_char_stats
@export var enemy_stats: CharacterStats :  set =  _set_enemy_stats
@export var end_turn_sound: AudioStream
@export var number_of_rounds: int : set = _set_number_of_rounds

@onready var hand: Hand = $PlayerHand
@onready var enemy_hand = $EnemyHand
@onready var draw_pile: ShowCardPile = %DrawPile
@onready var discard_pile: ShowCardPile = %DiscardPile
@onready var card_stack: CardStack = $CardStack
@onready var enemy_card_stack: CardStack =  $EnemyCardStack
@onready var end_turn_button: Button = %EndTurn
@onready var round_results = $RoundResults
@onready var end_game_panel = $EndGamePanel
@onready var temp_player_sprite = %TempPlayerSprite

func _ready():
	Events.player_cards_drawn.connect(_on_player_cards_drawn)
	Events.finished_comparing_stacks.connect(_on_finished_comparing_cards)
	Events.battle_completed.connect(_handle_battle_completed)
	Events.card_discarded.connect(_update_discard_pile_sprite)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)
	draw_pile.pressed.connect(func(): Events.show_card_pile.emit(char_stats.draw_pile, "Draw Pile", true))
	discard_pile.pressed.connect(func(): Events.show_card_pile.emit(char_stats.discard, "Discard Pile", false))

func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	card_stack.char_stats = char_stats
	card_stack.update_card_stack_ui()
	hand.char_stats = char_stats
	draw_pile.card_pile = char_stats.draw_pile
	discard_pile.card_pile = char_stats.discard
	draw_pile.texture_normal = char_stats.card_back_sprite
	discard_pile.texture_normal = null
	temp_player_sprite.sprite_frames = char_stats.portrait_spriteframes
	
	

func _set_enemy_stats(value: CharacterStats) -> void:
	enemy_stats = value
	enemy_card_stack.char_stats = enemy_stats
	enemy_card_stack.update_card_stack_ui()
	enemy_hand.char_stats =  enemy_stats
	
func _set_number_of_rounds(value: int) -> void:
	number_of_rounds = value
	if not round_results.get_child_count() == number_of_rounds:
		round_results.instantiate_round_check_boxes(number_of_rounds)
	
func _on_player_cards_drawn() -> void:
	end_turn_button.disabled = false

func _on_end_turn_button_pressed() -> void:
	hand.disable_cards_in_hand()
	SfxPlayer.play(end_turn_sound)
	end_turn_button.disabled = true
	Events.player_turn_ended.emit()

func _update_discard_pile_sprite(card: CardUI, which_character: String) -> void:
	if which_character == card_stack.stack_id:
		discard_pile.texture_normal = card.card.card_top_sprite

func _on_finished_comparing_cards(round_result: GlobalEnums.round_result) -> void:
	round_results.update_round_checkbox(round_result)

func _handle_battle_completed(battle_result: GlobalEnums.round_result) -> void:
	end_game_panel.show_battle_end_panel(battle_result)
	end_turn_button.visible = false
	hand.disable_cards_in_hand()
