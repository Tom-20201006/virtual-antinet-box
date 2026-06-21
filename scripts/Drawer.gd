extends Node3D
class_name Drawer

const INNER_WIDTH := 0.25
const INNER_DEPTH := 0.34
const WALL_THICKNESS := 0.012
const FLOOR_THICKNESS := 0.012
const WALL_HEIGHT := 0.074
const MAX_PULL_DISTANCE := 0.27

var drawer_id = "drawer_1"
var open_amount = 0.0
var closed_position = Vector3.ZERO
var max_pull_distance = MAX_PULL_DISTANCE

var visual_root: Node3D
var collision_root: Node3D
var contents_root: Node3D
var _selection_mesh: MeshInstance3D
var _handle_mesh: MeshInstance3D
var _gap_hint: MeshInstance3D


func _ready() -> void:
	if visual_root == null:
		build()
	set_open_amount(open_amount)


func build() -> void:
	if visual_root != null:
		return

	visual_root = Node3D.new()
	visual_root.name = "VisualRoot"
	add_child(visual_root)

	collision_root = Node3D.new()
	collision_root.name = "CollisionRoot"
	add_child(collision_root)

	contents_root = Node3D.new()
	contents_root.name = "ContentsRoot"
	contents_root.position = Vector3(0.0, FLOOR_THICKNESS * 0.85, 0.0)
	add_child(contents_root)

	var floor_color = Color(0.43, 0.33, 0.23, 1.0)
	var wall_color = Color(0.51, 0.39, 0.27, 1.0)
	var rail_color = Color(0.22, 0.18, 0.14, 1.0)
	var handle_color = Color(0.16, 0.13, 0.10, 1.0)

	_add_panel("WoodFloor", Vector3(0.0, -FLOOR_THICKNESS * 0.5, 0.0), Vector3(INNER_WIDTH + WALL_THICKNESS * 2.0, FLOOR_THICKNESS, INNER_DEPTH + WALL_THICKNESS * 2.0), floor_color)
	_add_panel("LeftWall", Vector3(-INNER_WIDTH * 0.5 - WALL_THICKNESS * 0.5, WALL_HEIGHT * 0.5, 0.0), Vector3(WALL_THICKNESS, WALL_HEIGHT, INNER_DEPTH + WALL_THICKNESS * 2.0), wall_color)
	_add_panel("RightWall", Vector3(INNER_WIDTH * 0.5 + WALL_THICKNESS * 0.5, WALL_HEIGHT * 0.5, 0.0), Vector3(WALL_THICKNESS, WALL_HEIGHT, INNER_DEPTH + WALL_THICKNESS * 2.0), wall_color)
	_add_panel("BackStop", Vector3(0.0, WALL_HEIGHT * 0.5, -INNER_DEPTH * 0.5 - WALL_THICKNESS * 0.5), Vector3(INNER_WIDTH + WALL_THICKNESS * 2.0, WALL_HEIGHT, WALL_THICKNESS), wall_color)
	_add_panel("FrontPanel", Vector3(0.0, WALL_HEIGHT * 0.44, INNER_DEPTH * 0.5 + WALL_THICKNESS * 0.5), Vector3(INNER_WIDTH + WALL_THICKNESS * 2.4, WALL_HEIGHT * 0.88, WALL_THICKNESS * 1.6), wall_color)
	_add_panel("LeftSlideRail", Vector3(-INNER_WIDTH * 0.5 - WALL_THICKNESS * 1.25, WALL_HEIGHT * 0.16, 0.0), Vector3(WALL_THICKNESS * 0.55, WALL_THICKNESS * 0.55, INNER_DEPTH * 0.92), rail_color)
	_add_panel("RightSlideRail", Vector3(INNER_WIDTH * 0.5 + WALL_THICKNESS * 1.25, WALL_HEIGHT * 0.16, 0.0), Vector3(WALL_THICKNESS * 0.55, WALL_THICKNESS * 0.55, INNER_DEPTH * 0.92), rail_color)

	_handle_mesh = _add_panel("PullHandle", Vector3(0.0, WALL_HEIGHT * 0.48, INNER_DEPTH * 0.5 + WALL_THICKNESS + 0.021), Vector3(0.11, 0.022, 0.028), handle_color)
	_add_panel("LabelPlate", Vector3(0.0, WALL_HEIGHT * 0.71, INNER_DEPTH * 0.5 + WALL_THICKNESS + 0.008), Vector3(0.15, 0.018, 0.003), Color(0.82, 0.72, 0.52, 1.0), false)

	_gap_hint = MeshInstance3D.new()
	_gap_hint.name = "InsertionGapHint"
	var gap_box = BoxMesh.new()
	gap_box.size = Vector3(INNER_WIDTH * 0.88, WALL_HEIGHT * 1.25, 0.004)
	_gap_hint.mesh = gap_box
	_gap_hint.position = Vector3(0.0, WALL_HEIGHT * 0.52, -INNER_DEPTH * 0.35)
	_gap_hint.material_override = _transparent_material(Color(1.0, 0.82, 0.10, 0.48))
	_gap_hint.visible = false
	_gap_hint.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	visual_root.add_child(_gap_hint)

	_selection_mesh = MeshInstance3D.new()
	_selection_mesh.name = "SelectionHint"
	var selection_box = BoxMesh.new()
	selection_box.size = Vector3(INNER_WIDTH + 0.05, WALL_HEIGHT + 0.035, INNER_DEPTH + 0.08)
	_selection_mesh.mesh = selection_box
	_selection_mesh.position.y = WALL_HEIGHT * 0.35
	_selection_mesh.material_override = _transparent_material(Color(0.2, 0.75, 1.0, 0.22))
	_selection_mesh.visible = false
	_selection_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	visual_root.add_child(_selection_mesh)


func get_interaction_type() -> String:
	return "drawer"


func set_selected(selected: bool) -> void:
	if _selection_mesh != null:
		_selection_mesh.visible = selected
	if not selected:
		clear_insertion_preview()


func set_open_amount(value: float) -> void:
	open_amount = clamp(value, 0.0, 1.0)
	position = closed_position + Vector3(0.0, 0.0, open_amount * max_pull_distance)
	if _gap_hint != null and open_amount < 0.15:
		_gap_hint.visible = false


func adjust_open_amount(delta: float) -> void:
	set_open_amount(open_amount + delta)


func toggle_open() -> void:
	if open_amount < 0.5:
		set_open_amount(1.0)
	else:
		set_open_amount(0.0)


func contains_world_point(world_point: Vector3) -> bool:
	if open_amount < 0.12:
		return false
	var local = to_local(world_point)
	return abs(local.x) <= INNER_WIDTH * 0.5 + 0.045 \
		and local.z >= -INNER_DEPTH * 0.5 - 0.045 \
		and local.z <= INNER_DEPTH * 0.5 + 0.055 \
		and local.y >= -0.04 \
		and local.y <= WALL_HEIGHT + 0.17


func add_item(item: Node, world_drop_point: Variant = null) -> void:
	var slot = get_item_count()
	if world_drop_point != null:
		slot = _insertion_index_for_local_z(to_local(world_drop_point).z)
	_insert_item_at(item, slot)


func add_loaded_item(item: Node, slot_index: int) -> void:
	_insert_item_at(item, slot_index)


func get_item_count() -> int:
	return _get_card_like_children().size()


func get_saved_open_amount() -> float:
	return open_amount


func preview_insertion_at_world_point(world_point: Vector3) -> void:
	if _gap_hint == null or open_amount < 0.12:
		return
	var index = _insertion_index_for_local_z(to_local(world_point).z)
	var preview_position = _storage_position(index, get_item_count() + 1, null)
	_gap_hint.position = Vector3(0.0, WALL_HEIGHT * 0.52, preview_position.z)
	_gap_hint.visible = true


func clear_insertion_preview() -> void:
	if _gap_hint != null:
		_gap_hint.visible = false


func _insert_item_at(item: Node, slot_index: int) -> void:
	item.reparent(contents_root, true)
	var child_count = contents_root.get_child_count()
	contents_root.move_child(item, clamp(slot_index, 0, max(child_count - 1, 0)))
	_relayout_items()
	item.end_drag()
	clear_insertion_preview()


func _relayout_items() -> void:
	var items = _get_card_like_children()
	for index in range(items.size()):
		var item = items[index]
		item.area_id = drawer_id
		item.position = _storage_position(index, items.size(), item)
		if item.has_method("align_for_storage"):
			item.align_for_storage(index)


func _storage_position(index: int, total_count: int = 1, item: Node = null) -> Vector3:
	var usable_depth = INNER_DEPTH * 0.76
	var spacing = clamp(usable_depth / max(total_count + 1, 1), 0.007, 0.015)
	var start_z = -usable_depth * 0.5 + spacing
	var card_height = 0.1016
	if item != null and item.get("card_size") != null:
		card_height = item.get("card_size").z
	var y_offset = card_height * 0.5 + FLOOR_THICKNESS * 0.15
	var x_offset = sin(float(index) * 1.71) * 0.0025
	return Vector3(x_offset, y_offset, start_z + index * spacing)


func _insertion_index_for_local_z(local_z: float) -> int:
	var items = _get_card_like_children()
	for index in range(items.size()):
		if local_z < items[index].position.z:
			return index
	return items.size()


func _get_card_like_children() -> Array:
	var result: Array = []
	for child in contents_root.get_children():
		if _is_card_like(child):
			result.append(child)
	return result


func _is_card_like(node: Node) -> bool:
	if node == null or not node.has_method("get_interaction_type"):
		return false
	var interaction_type = node.get_interaction_type()
	return interaction_type == "card" or interaction_type == "divider"


func _add_panel(panel_name: String, panel_position: Vector3, panel_size: Vector3, color: Color, collision: bool = true) -> MeshInstance3D:
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.name = panel_name
	var box = BoxMesh.new()
	box.size = panel_size
	mesh_instance.mesh = box
	mesh_instance.position = panel_position
	mesh_instance.material_override = _material(color)
	visual_root.add_child(mesh_instance)

	if collision:
		var body = StaticBody3D.new()
		body.name = "%sCollision" % panel_name
		body.position = panel_position
		var shape = CollisionShape3D.new()
		var box_shape = BoxShape3D.new()
		box_shape.size = panel_size
		shape.shape = box_shape
		body.add_child(shape)
		collision_root.add_child(body)
	return mesh_instance


func _material(color: Color) -> StandardMaterial3D:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.90
	return mat


func _transparent_material(color: Color) -> StandardMaterial3D:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	return mat
