class_name CardMenuUI extends CenterContainer

signal tooltip_requested(card: Card)

@export var card: Card: set = set_card
@export var angle_x_max: float
@export var angle_y_max: float

@onready var visuals = $Visuals

func _ready():
	angle_x_max = deg_to_rad(angle_x_max)
	angle_y_max = deg_to_rad(angle_y_max)

func _on_visuals_mouse_entered() -> void:
	visuals.card_sprite.material.set_shader_parameter("inset", 0)


func _on_visuals_mouse_exited() -> void:
	visuals.card_sprite.material.set_shader_parameter("x_rot", 0)
	visuals.card_sprite.material.set_shader_parameter("y_rot", 0)

	visuals.card_sprite.material.set_shader_parameter("inset", 0.15)

func _on_visuals_gui_input(event):
	if event.is_action_pressed("left_mouse"):
		tooltip_requested.emit(card)

	if event is InputEventMouseMotion:
		var mouse_pos: Vector2 = visuals.card_sprite.get_local_mouse_position()
		#var diff: Vector2 = (card_ui.position + card_ui.size) - mouse_pos
		
		var lerp_val_x: float = remap(mouse_pos.x, 0.0, visuals.card_sprite.size.x, 0,1)
		var lerp_val_y: float = remap(mouse_pos.y, 0.0, visuals.card_sprite.size.y, 0,1)
		
		var rot_x: float = rad_to_deg(lerp_angle(-angle_x_max, angle_x_max, lerp_val_x))
		var rot_y: float = rad_to_deg(lerp_angle(angle_y_max, -angle_y_max, lerp_val_y))
		
		visuals.card_sprite.material.set_shader_parameter("x_rot", rot_y)
		visuals.card_sprite.material.set_shader_parameter("y_rot", rot_x)
	
func set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	if not value:
		return
	card = value
	visuals.card = card
