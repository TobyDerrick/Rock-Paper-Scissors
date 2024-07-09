class_name MapRoom extends Area2D

signal selected(room: Room)

const ICONS := {
	Room.Type.NOT_ASSIGNED: [null, Vector2.ONE],
	Room.Type.BATTLE: [preload("res://ART/CARDS/CardBacks/card_back_spotty.png"), Vector2(-0.6,-0.6)],
	Room.Type.EVENT: [preload("res://ART/questionmark.png"), Vector2.ZERO],
	Room.Type.SHOP: [preload("res://ART/UI/coinIcon.png"), Vector2.ZERO],
	Room.Type.REST: [preload("res://ART/UI/style_box.png"), Vector2(-0.6,-0.6)],
	Room.Type.BOSS: [preload("res://ART/UI/endcross.png"), Vector2(0.25, 0.25)]
}

@onready var sprite_2d = $Visuals/Sprite2D
@onready var line_2d = $Visuals/Line2D
@onready var animation_player = $AnimationPlayer

@export var hover_audio: AudioStream
@export var press_audio: AudioStream

var available := false : set = set_available
var room: Room : set = set_room

func set_available(value: bool):
	available = value
	
	if available:
		animation_player.play("highlight")
	
	elif not room.selected:
		animation_player.play("RESET")
	
	
func set_room(value: Room) -> void:
	room = value
	position = room.position
	line_2d.rotation_degrees = randi_range(0, 360)
	sprite_2d.texture = ICONS[room.type][0]
	sprite_2d.scale +=  ICONS[room.type][1]
	
func show_selected() -> void:
	line_2d.modulate = Color.WHITE
	
	
func _on_input_event(viewport, event, shape_idx):
	if not available or not event.is_action_pressed("left_mouse"):
		return
		
	SfxPlayer.play(press_audio)
	room.selected = true
	animation_player.play("select")
	
func _on_map_room_selected() -> void:
	selected.emit(room)


func _on_mouse_entered():
	if not available: return
	SfxPlayer.play(hover_audio)
