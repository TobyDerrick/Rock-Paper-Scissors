class_name Battle extends Node2D

@export var char_stats: CharacterStats : set = set_char_stats
@export var enemy_stats: CharacterStats
@export var best_of: float =  3
@export var battle_win_sound: AudioStream
@export var battle_loss_sound: AudioStream

@onready var battle_ui: BattleUI = $BattleUI as BattleUI
@onready var player_handler: PlayerHandler = $PlayerHandler as PlayerHandler
@onready var enemy_handler: EnemyHandler = $EnemyHandler as EnemyHandler

var round_wins: float = 0
var round_losses: float = 0 

func set_char_stats(value: CharacterStats) -> void:
	if not is_node_ready():
		await ready
	char_stats = value

func initialise_battle() -> void:
	var enemy_new_stats: CharacterStats = enemy_stats.create_instance()
	start_battle(char_stats, enemy_new_stats)
	battle_ui.char_stats = char_stats
	battle_ui.enemy_stats = enemy_stats
	battle_ui.number_of_rounds = best_of
	Events.player_turn_ended.connect(enemy_handler.start_turn)
	Events.finished_comparing_stacks.connect(player_handler.start_turn)
	Events.finished_comparing_stacks.connect(_on_finished_comparing_stacks)
	Events.battle_completed.connect(_battle_completed)

func start_battle(stats: CharacterStats, enemy_char_stats: CharacterStats) -> void:
	MusicPlayer.fade_intensity(1, 1)
	player_handler.start_battle(stats)
	enemy_handler.start_battle(enemy_char_stats)
	
func _on_finished_comparing_stacks(round_result: GlobalEnums.round_result):
	if round_result == GlobalEnums.round_result.WIN:
		round_wins += 1
	
	elif round_result == GlobalEnums.round_result.LOSE:
		round_losses += 1
	
	if round_wins >= round(best_of / 2) or round_losses >= round(best_of / 2):
		Events.battle_completed.emit(round_result)

func _battle_completed(round_result: GlobalEnums.round_result):
	if round_result == GlobalEnums.round_result.WIN:
		SfxPlayer.play(battle_win_sound, true)
	else:
		SfxPlayer.play(battle_loss_sound, true)
	
