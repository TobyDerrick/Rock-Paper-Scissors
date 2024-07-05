class_name RewardButton extends Button

@export var this_reward_icon: Texture :  set = set_reward_icon
@export var this_reward_text: String : set = set_reward_text

@onready var reward_icon = %RewardIcon
@onready var reward_text = %RewardText

func set_reward_icon(value: Texture) -> void:
	this_reward_icon = value
	
	if not is_node_ready():
		await ready
	
	reward_icon.texture = this_reward_icon


func set_reward_text(value: String) -> void:
	this_reward_text = value
	
	if not is_node_ready():
		await ready
	
	reward_text.text = this_reward_text

func _on_pressed():
	queue_free()
