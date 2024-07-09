class_name Run extends Node

const BATTLE = preload("res://SCENES/Battle/battle.tscn")
const BATTLE_REWARDS = preload("res://SCENES/BattleRewards/battle_rewards.tscn")
const REST = preload("res://SCENES/Rest/rest.tscn")
const SHOP = preload("res://SCENES/Shop/shop.tscn")
const SPECIAL_EVENT = preload("res://SCENES/SpecialEvents/special_event.tscn")

@export var run_startup: RunStartup
@export var gameplay_song: OvaniSong

@onready var current_scene = $CurrentScene
@onready var map_button = %MapButton
@onready var battle_button = %BattleButton
@onready var battle_rewards_button = %BattleRewardsButton
@onready var shop_button = %ShopButton
@onready var rest_button = %RestButton
@onready var event_button = %EventButton
@onready var coins_ui = %CoinsUI
@onready var map: Map = $Map


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
	MusicPlayer.play_song(gameplay_song)
	MusicPlayer.fade_intensity(0, 1)
	
	map.generate_new_map()
	map.unlock_floor(0)

func _change_view(scene: PackedScene) -> Node:
	if current_scene.get_child_count() > 0:
		current_scene.get_child(0).queue_free()
		
	get_tree().paused = false
	var new_scene := scene.instantiate()
	current_scene.add_child(new_scene)
	map.hide_map()
	
	return new_scene
	
func show_map() -> void:
	ScreenTransition.play_transition()
	await Events.trans_out_complete
	
	if current_scene.get_child_count() > 0:
		current_scene.get_child(0).queue_free()
	
	map.show_map()
	map.unlock_next_rooms()
	
func _setup_event_connections() -> void:
	#setup event connections
	Events.battle_won.connect(_on_battle_won)
	Events.battle_rewards_exited.connect(show_map)
	Events.rest_exited.connect(show_map)
	Events.special_event_exited.connect(show_map) #TODO: ALTER WHEN SPECIAL EVENTS IMPLEMENTED
	Events.shop_exited.connect(show_map)
	Events.map_exited.connect(_on_map_exited)
	
	#setup debug button connections
	battle_button.pressed.connect(_on_battle_entered)
	battle_rewards_button.pressed.connect(_change_view.bind(BATTLE_REWARDS))
	rest_button.pressed.connect(_change_view.bind(REST))
	map_button.pressed.connect(show_map)
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
	reward_scene.add_coin_reward(2)
	reward_scene.add_card_reward()
	
func _on_map_exited(room: Room) -> void:
	ScreenTransition.play_transition()
	await Events.trans_out_complete
	match room.type:
		Room.Type.BATTLE:
			var battle_scene := _change_view(BATTLE) as Battle
			battle_scene.char_stats = character
			battle_scene.initialise_battle()
		Room.Type.SHOP:
			_change_view(SHOP)
		Room.Type.EVENT:
			_change_view(SPECIAL_EVENT)
		Room.Type.REST:
			_change_view(REST)
		Room.Type.BOSS:
			_change_view(BATTLE)
			
