extends Node

#Battle signals
signal battle_completed(battle_result: GlobalEnums.round_result)
signal card_used(card_used: CardUI)
signal card_discarded(card_discarded: CardUI, character_id: String)
signal battle_won

signal show_card_pile(card_pile: CardPile, pile_name: String, randomized: bool)
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

#Battle Rewards Events
signal battle_rewards_exited
#Map Events
signal map_exited(room: Room)
#Shop Events
signal shop_exited
#Rest Events
signal rest_exited
#Special Event Events
signal special_event_exited


