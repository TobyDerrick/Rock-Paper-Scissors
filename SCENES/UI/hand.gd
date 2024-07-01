class_name Hand extends Control

signal card_added_to_hand(card: CardUI)
@export var char_stats: CharacterStats
@export var hand_id: String
@export var hand_pos_curve: Curve
@export var height_curve: Curve
@export var rotation_curve: Curve
@export var max_card_spread: float

@onready var card_ui := preload("res://SCENES/Battle/card_ui.tscn")

func _ready():
	child_order_changed.connect(update_card_ui)

func add_card(card: Card) -> void:
	var new_card_ui := card_ui.instantiate()
	add_child(new_card_ui)
	new_card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)
	new_card_ui.card = card
	new_card_ui.char_stats = char_stats
	new_card_ui.reparent_requested.emit(new_card_ui, hand_id)
	
	if hand_id == "hand":
		new_card_ui.is_playable = true
	
	else:
		new_card_ui.is_playable = false
		
	card_added_to_hand.emit(new_card_ui)

func disable_cards_in_hand() -> void:
	for card_ui in get_children():
		card_ui.is_playable = false
	
func enable_cards_in_hand() -> void:
	for card_ui in get_children():
		card_ui.is_playable = true

func update_card_ui():
	var hand_size: Vector2 = get_size()
	for this_card: CardUI in get_children():
		this_card.pivot_offset = this_card.size / 2
		var hand_ratio = 0.5
		
		if get_child_count() > 1:
			hand_ratio = float(this_card.get_index()) / float(get_child_count() - 1)
		
		var destination :=  global_position 
		
		destination.x += hand_pos_curve.sample(hand_ratio) * hand_size.x/2
		destination.y -= height_curve.sample(hand_ratio) * 5
		
		
		#card_ui.rotation = rotation_curve.sample(hand_ratio) * 0.3
		destination.x += size.x / 2
		this_card.global_position = destination
		
func discard_card(card: CardUI) -> void:
	card.queue_free()
	
func _on_card_ui_reparent_requested(child: CardUI, target_pos: String) -> void:
	if(target_pos == hand_id):
		update_card_ui()
		child.reparent(self)
	
func _card_removed_from_hand():
	update_card_ui()
