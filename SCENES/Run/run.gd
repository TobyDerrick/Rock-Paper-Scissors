class_name Run extends Node

const BATTLE = preload("res://SCENES/Battle/battle.tscn")
const BATTLE_REWARDS = preload("res://SCENES/BattleRewards/battle_rewards.tscn")
const MAP = preload("res://SCENES/Map/map.tscn")
const REST = preload("res://SCENES/Rest/rest.tscn")
const SHOP = preload("res://SCENES/Shop/shop.tscn")
const SPECIAL_EVENT = preload("res://SCENES/SpecialEvents/special_event.tscn")

@export var run_startup: RunStartup

@onready var current_scene = $CurrentScene
@onready var map_button = %MapButton
@onready var battle_button = %BattleButton
@onready var battle_rewards_button = %BattleRewardsButton
@onready var shop_button = %ShopButton
@onready var rest_button = %RestButton
@onready var event_button = %EventButton
@onready var coins_ui = %CoinsUI

var run_stats: RunStats
var character: CharacterStats

func _ready():
	if not run_startup:
		return
	
	match run_startup.type:
		RunStartup.run_type.NEW_RUN:
			character = run_startup.character.create_instance()
			character.deck = character.starting_deck.duplicate()
			_start_run()
		
		RunStartup.run_type.CONTINUED_RUN:
			print("continued runs not yet implemented")
	
func _start_run() -> void:
	run_stats = RunStats.new()
	_setup_event_connections()
	coins_ui.run_stats = run_stats
	MusicPlayer.fade_intensity(0.5, 1)

func _change_view(scene: PackedScene) -> Node:
	if current_scene.get_child_count() > 0:
		current_scene.get_child(0).queue_free()
		
	get_tree().paused = false
	var new_scene := scene.instantiate()
	current_scene.add_child(new_scene)
	
	return new_scene
	
func _setup_event_connections() -> void:
	#setup event connections
	Events.battle_won.connect(_on_battle_won)
	Events.battle_rewards_exited.connect(_change_view.bind(MAP))
	Events.rest_exited.connect(_change_view.bind(MAP))
	Events.special_event_exited.connect(_change_view.bind(MAP)) #TODO: ALTER WHEN SPECIAL EVENTS IMPLEMENTED
	Events.shop_exited.connect(_change_view.bind(MAP))
	Events.map_exited.connect(_on_map_exited)
	
	#setup debug button connections
	battle_button.pressed.connect(_on_battle_entered)
	battle_rewards_button.pressed.connect(_change_view.bind(BATTLE_REWARDS))
	rest_button.pressed.connect(_change_view.bind(REST))
	map_button.pressed.connect(_change_view.bind(MAP))
	shop_button.pressed.connect(_change_view.bind(SHOP))
	event_button.pressed.connect(_change_view.bind(SPECIAL_EVENT))
	
func _on_battle_entered() -> void:
	var battle_scene := _change_view(BATTLE) as Battle
	battle_scene.char_stats = character
	battle_scene.initialise_battle()
	
func _on_battle_won() -> void:
	var reward_scene := _change_view(BATTLE_REWARDS) as BattleRewards
	reward_scene.run_stats = run_stats
	reward_scene.character_stats = character
	reward_scene.add_coin_reward(50)
	reward_scene.add_card_reward()
func _on_map_exited() -> void:
	pass
