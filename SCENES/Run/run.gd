class_name Run extends Node

const BATTLE = preload("res://SCENES/Battle/battle.tscn")
const BATTLE_REWARDS = preload("res://SCENES/BattleRewards/battle_rewards.tscn")
const MAP = preload("res://SCENES/Map/map.tscn")
const REST = preload("res://SCENES/Rest/rest.tscn")
const SHOP = preload("res://SCENES/Shop/shop.tscn")
const SPECIAL_EVENT = preload("res://SCENES/SpecialEvents/special_event.tscn")

@onready var current_scene = $CurrentScene
@onready var map_button = %MapButton
@onready var battle_button = %BattleButton
@onready var battle_rewards_button = %BattleRewardsButton
@onready var shop_button = %ShopButton
@onready var rest_button = %RestButton
@onready var event_button = %EventButton

var character: CharacterStats

func _ready():
	if not character:
		var diego := load("res://CHARACTERS/Diego/diego_stats.tres")
		character = diego.create_instance()
		_start_run()
	
func _start_run() -> void:
	_setup_event_connections()

func _change_view(scene: PackedScene) -> void:
	if current_scene.get_child_count() > 0:
		current_scene.get_child(0).queue_free()
		
	get_tree().paused = false
	var new_scene := scene.instantiate()
	current_scene.add_child(new_scene)
	
func _setup_event_connections() -> void:
	#setup event connections
	Events.battle_won.connect(_change_view.bind(BATTLE_REWARDS))
	Events.battle_rewards_exited.connect(_change_view.bind(MAP))
	Events.rest_exited.connect(_change_view.bind(MAP))
	Events.special_event_exited.connect(_change_view.bind(MAP)) #TODO: ALTER WHEN SPECIAL EVENTS IMPLEMENTED
	Events.shop_exited.connect(_change_view.bind(MAP))
	Events.map_exited.connect(_on_map_exited)
	
	#setup debug button connections
	battle_button.pressed.connect(_change_view.bind(BATTLE))
	battle_rewards_button.pressed.connect(_change_view.bind(BATTLE_REWARDS))
	rest_button.pressed.connect(_change_view.bind(REST))
	map_button.pressed.connect(_change_view.bind(MAP))
	shop_button.pressed.connect(_change_view.bind(SHOP))
	event_button.pressed.connect(_change_view.bind(SPECIAL_EVENT))
	
	
func _on_map_exited() -> void:
	pass
