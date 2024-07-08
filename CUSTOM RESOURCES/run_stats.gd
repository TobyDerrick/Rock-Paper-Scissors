class_name RunStats extends Resource

signal coins_changed

const STARTING_COINS := 0
const BASE_CARD_REWARDS := 3
const BASE_COMMON_WEIGHT := 6.0
const BASE_UNCOMMON_WEIGHT := 3.7
const BASE_RARE_WEIGHT := 0.3

@export var coins := STARTING_COINS : set = set_coins
@export var card_rewards := BASE_CARD_REWARDS
@export_range(0.0,10.0) var common_weight := BASE_COMMON_WEIGHT
@export_range(0.0,10.0) var uncommon_weight := BASE_UNCOMMON_WEIGHT
@export_range(0.0,10.0) var rare_weight := BASE_RARE_WEIGHT


func set_coins(new_amount: int) -> void:
	coins = new_amount
	coins_changed.emit()

func reset_weights() -> void:
	common_weight = BASE_COMMON_WEIGHT
	uncommon_weight = BASE_UNCOMMON_WEIGHT
	rare_weight = BASE_RARE_WEIGHT
