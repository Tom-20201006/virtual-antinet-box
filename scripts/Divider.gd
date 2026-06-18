extends "res://scripts/Card.gd"
class_name Divider


func _ready() -> void:
	object_kind = "divider"
	uses_placeholder_texture = false
	card_size = Vector3(CARD_WIDTH, CARD_THICKNESS * 2.0, CARD_DEPTH * 1.18)
	front_color = Color(0.38, 0.66, 0.82, 1.0)
	back_color = Color(0.34, 0.58, 0.74, 1.0)
	edge_color = Color(0.18, 0.36, 0.46, 1.0)
	super._ready()


func get_interaction_type() -> String:
	return "divider"

