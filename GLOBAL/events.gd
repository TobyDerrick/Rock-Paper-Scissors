extends Node

#Battle signals

signal battle_completed(battle_result: GlobalEnums.round_result)

#Player Signals
signal player_hand_drawn
signal player_cards_drawn
signal player_turn_ended

#Enemy Signals
signal enemy_hand_drawn
signal enemy_cards_drawn
signal enemy_turn_ended

#Compare Phase Signals
signal finished_comparing_stacks(round_result: GlobalEnums.round_result)

