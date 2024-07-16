class_name BattleRewards extends Control

enum Type {COIN, NEW_CARD}

const CARD_REWARDS = preload("res://SCENES/UI/card_rewards.tscn")
const REWARD_BUTTON = preload("res://SCENES/UI/reward_button.tscn")
const COIN_ICON := preload("res://ART/UI/coinIcon.png")
const COIN_TEXT := "%s coins"
const CARD_ICON := preload("res://ART/CARDS/CardBacks/card_back_spotty.png")
const CARD_TEXT := "Add New Card"

@export var run_stats: RunStats
@export var character_stats: CharacterStats

@onready var rewards = %Rewards

var card_reward_total_weight := 0.0
var card_rarity_weights := {
	Card.Rarity.COMMON: 0.0,
	Card.Rarity.UNCOMMON: 0.0,
	Card.Rarity.RARE: 0.0 
							}

func _ready():
	for node in rewards.get_children():
		node.queue_free()
	MusicPlayer.fade_intensity(0, 1)
	
func add_card_reward() -> void:
	var card_reward := REWARD_BUTTON.instantiate() as RewardButton
	card_reward.this_reward_icon = CARD_ICON
	card_reward.this_reward_text = CARD_TEXT
	card_reward.pressed.connect(_show_card_rewards)
	rewards.add_child.call_deferred(card_reward)
	
func add_coin_reward(amount: int) -> void:
	var coin_reward := REWARD_BUTTON.instantiate() as RewardButton
	coin_reward.this_reward_icon = COIN_ICON
	coin_reward.this_reward_text = COIN_TEXT % amount
	coin_reward.pressed.connect(_on_coin_reward_taken.bind(amount))
	rewards.add_child.call_deferred(coin_reward)
	
func _on_coin_reward_taken(amount: int) -> void:
	if not run_stats:
		return
	
	run_stats.coins += amount

func _show_card_rewards() -> void:
	if not run_stats or not character_stats:
		return
	
	var card_rewards := CARD_REWARDS.instantiate() as CardRewards
	add_child(card_rewards)
	card_rewards.card_reward_selected.connect(_on_card_reward_taken)
	
	var available_cards: Array[Card] = character_stats.draftable_cards.cards
	var reward_array: Array[Card] = []
	
	for i in run_stats.card_rewards:
		_setup_card_chances()
		var roll := randf_range(0.0, card_reward_total_weight)
		
		for rarity: Card.Rarity in card_rarity_weights:
			if card_rarity_weights[rarity] > roll:
				_modify_weights(rarity)
				var picked_card := _get_random_available_card(available_cards).duplicate()
				picked_card.rarity = rarity
				reward_array.append(picked_card)
				break
	
	card_rewards.rewards = reward_array
	card_rewards.show()
	
func _setup_card_chances() -> void:
	card_reward_total_weight = run_stats.common_weight + run_stats.uncommon_weight + run_stats.rare_weight
	card_rarity_weights[Card.Rarity.COMMON] = run_stats.common_weight
	card_rarity_weights[Card.Rarity.UNCOMMON] = run_stats.common_weight + run_stats.uncommon_weight
	card_rarity_weights[Card.Rarity.RARE] = card_reward_total_weight
	
func _modify_weights(rarity_rolled: Card.Rarity):
	if rarity_rolled == Card.Rarity.RARE:
		run_stats.rare_weight = RunStats.BASE_RARE_WEIGHT
	
	else:
		run_stats.rare_weight = clampf(run_stats.rare_weight + 0.3, run_stats.BASE_RARE_WEIGHT, 5)
			
func _get_random_available_card(available_cards: Array[Card]) -> Card:
	return available_cards.pick_random()
		
func _on_card_reward_taken(card: Card) -> void:
	if not character_stats or not card:
		return
		
	character_stats.deck.add_card(card)
	
func _on_button_pressed():
	Events.battle_rewards_exited.emit()
