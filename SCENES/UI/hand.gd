class_name Hand extends Control

signal card_added_to_hand(card: CardUI)
@export var char_stats: CharacterStats
@export var hand_id: String
@export var hand_pos_curve: Curve
@export var height_curve: Curve
@export var rotation_curve: Curve
@export var max_spread: int

@onready var card_ui := preload("res://SCENES/Battle/card_ui.tscn")

func _ready():
	child_order_changed.connect(_handle_child_order_changed)

func add_card(card: Card) -> void:
	var new_card_ui := card_ui.instantiate()
	new_card_ui.char_stats = char_stats
	add_child(new_card_ui)
	new_card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)
	new_card_ui.card = card
	new_card_ui.reparent_requested.emit(new_card_ui, hand_id)
	
	if hand_id == "hand":
		new_card_ui.card_flip()
		new_card_ui.is_playable = true
	
	else:
		new_card_ui.is_playable = false
		
	card_added_to_hand.emit(new_card_ui)

func disable_cards_in_hand() -> void:
	for child in get_children():
		if child is CardUI:
			child.is_playable = false
	
func enable_cards_in_hand() -> void:
	for child in get_children():
		if child is CardUI:
			child.is_playable = true

func update_card_ui():
	var total_cards_in_hand: int = get_child_count()
	#generating hand ratio for the curves
	for this_card in get_children():
		if not this_card is CardUI:
			continue
		
		this_card.pivot_offset = this_card.size / 2
		var hand_ratio = 0.5
		
		if get_child_count() > 1:
			hand_ratio = float(this_card.get_index()) / float(get_child_count() - 1)
		
		#print_debug(hand_ratio)
		var destination : Vector2 = global_position
		destination += size / 2
		
		
		destination.x -= hand_pos_curve.sample(hand_ratio) * min(size.x / 2, max_spread * total_cards_in_hand)
		destination.y -= height_curve.sample(hand_ratio) * 5
		
		
		this_card.global_position = destination
		this_card.rotation = rotation_curve.sample(hand_ratio) * 0.1
		this_card.base_position = this_card.position
		
func discard_card(card: CardUI) -> void:
	card.queue_free()
	
func _on_card_ui_reparent_requested(child: CardUI, target_pos: String) -> void:
	if(target_pos == hand_id):
		child.reparent(self)
		update_card_ui()
	
func _handle_child_order_changed():
	update_card_ui()
