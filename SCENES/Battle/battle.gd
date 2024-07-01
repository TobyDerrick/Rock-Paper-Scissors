extends Node2D

@export var char_stats: CharacterStats
@export var enemy_stats: CharacterStats
@export var best_of: float =  3
@export var music: AudioStream

@onready var battle_ui: BattleUI = $BattleUI as BattleUI
@onready var player_handler: PlayerHandler = $PlayerHandler as PlayerHandler
@onready var enemy_handler: EnemyHandler = $EnemyHandler as EnemyHandler

var round_wins: float = 0
var round_losses: float = 0 

func _ready():
	#TODO: move this to a seperate function when expanded into multiple battles
	var new_stats: CharacterStats = char_stats.create_instance()
	var enemy_new_stats: CharacterStats = enemy_stats.create_instance()
	battle_ui.char_stats = new_stats
	battle_ui.enemy_stats = enemy_stats
	start_battle(new_stats, enemy_new_stats)
	Events.player_turn_ended.connect(enemy_handler.start_turn)
	Events.finished_comparing_stacks.connect(player_handler.start_turn)
	Events.finished_comparing_stacks.connect(_on_finished_comparing_stacks)
	
func start_battle(stats: CharacterStats, enemy_char_stats: CharacterStats) -> void:
	MusicPlayer.play(music, true)
	player_handler.start_battle(stats)
	enemy_handler.start_battle(enemy_char_stats)
	
func _on_finished_comparing_stacks(round_result: GlobalEnums.round_result):
	if round_result == GlobalEnums.round_result.WIN:
		round_wins += 1
	
	elif round_result == GlobalEnums.round_result.LOSE:
		round_losses += 1
	
	if round_wins >= round(best_of / 2) or round_losses >= round(best_of / 2):
		Events.battle_completed.emit(round_result)
