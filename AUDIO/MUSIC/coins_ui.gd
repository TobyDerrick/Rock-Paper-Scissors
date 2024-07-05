class_name coins_ui extends HBoxContainer

@export var run_stats: RunStats : set = set_run_stats

@onready var label = $Label

func _ready():
	label.text = "0"

func set_run_stats(value: RunStats) -> void:
	run_stats = value
	
	if not run_stats.coins_changed.is_connected(_update_coins):
		run_stats.coins_changed.connect(_update_coins)
		_update_coins()
		
func _update_coins() -> void:
	label.text = str(run_stats.coins)
