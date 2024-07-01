class_name CardUI extends Control

signal reparent_requested(which_card: CardUI, target_pos: String)

@export var char_stats: CharacterStats
@export var card: Card : set = _set_card_sprite

@onready var colour: ColorRect = $Colour
@onready var state: Label = $State
@onready var card_bottom = $CardBottom
@onready var card_top = $CardBottom/CardTop
@onready var card_flipper = $CardFlip
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var drop_point_detector = $DropPointDetector
@onready var targets: Array[Node] = []

var is_playable: bool

func _ready():
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
	card_top.texture = card.card_top_sprite
	card_bottom.texture = char_stats.card_back_sprite 
	card_top.z_index = -1
func card_flip():
	card_flipper.play("card_flip")
