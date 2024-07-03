extends Panel

@onready var claim_rewards_button = $ClaimRewardsButton
@onready var rich_text_label = $RichTextLabel

func show_battle_end_panel(battle_result: GlobalEnums.round_result):
	claim_rewards_button.visible = battle_result == GlobalEnums.round_result.WIN
	if battle_result == GlobalEnums.round_result.WIN:
		rich_text_label.text = "[center][wave amp=20.0 freq=8.0 connected=1][rainbow freq=1.0 sat=0.8 val=1.0]You Win![/rainbow] [/wave] [/center]"
	elif battle_result == GlobalEnums.round_result.LOSE:
		rich_text_label.text = "[center][wave amp=20.0 freq=8.0 connected=1][rainbow freq=1.0 sat=0.8 val=1.0]You Lose![/rainbow] [/wave] [/center]"
	show()


func _on_claim_rewards_button_pressed():
	Events.battle_won.emit()
