class_name CardUI extends Control

signal reparent_requested(which_card: CardUI, target_pos: String)

@export var char_stats: CharacterStats
@export var card: Card : set = _set_card_sprite
@export_group("perspective settings")
@export var angle_x_max: float
@export var angle_y_max: float

@onready var card_visuals = $CardVisuals
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var drop_point_detector = $DropPointDetector
@onready var targets: Array[Node] = []

var base_position: Vector2
var is_playable: bool

func _ready():
	angle_x_max = deg_to_rad(angle_x_max)
	angle_y_max = deg_to_rad(angle_y_max)
	card_state_machine.init(self)
	
func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)

func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)
	
func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()

func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()
	
func _on_drop_point_detector_area_entered(area) -> void:
	if not targets.has(area):
		targets.append(area)
		
func _on_drop_point_detector_area_exited(area) -> void:
	targets.erase(area)

func _set_card_sprite(value: Card) -> void:
	if not is_node_ready():
		await ready
	
	card = value
	card_visuals.card = card
	card_visuals.card_bottom_sprite = char_stats.card_back_sprite

	card_visuals.card_top_sprite = card.card_top_sprite
	
func card_flip():
	card_visuals.card_flip.play("card_flip")
