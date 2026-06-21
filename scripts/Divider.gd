extends "res://scripts/Card.gd"
class_name Divider


func _ready() -> void:
	object_kind = "divider"
	physical_profile = "divider_tab"
	has_tab = true
	if tab_label.is_empty():
		tab_label = "A"
	apply_physical_profile("divider_tab")
	super._ready()


func get_interaction_type() -> String:
	return "divider"
