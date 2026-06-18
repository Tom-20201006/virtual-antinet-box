extends Node3D
class_name Drawer

const CARD_THICKNESS := 0.0015
const INNER_WIDTH := 0.25
const INNER_DEPTH := 0.32
const WALL_THICKNESS := 0.012
const FLOOR_THICKNESS := 0.012
const WALL_HEIGHT := 0.065
const MAX_PULL_DISTANCE := 0.24

var drawer_id = "drawer_1"
var open_amount = 0.0
var closed_position = Vector3.ZERO
var max_pull_distance = MAX_PULL_DISTANCE

var visual_root: Node3D
var collision_root: Node3D
var contents_root: Node3D
var _selection_mesh: MeshInstance3D
var _handle_mesh: MeshInstance3D


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
	contents_root.position = Vector3(0.0, FLOOR_THICKNESS * 0.75, 0.0)
	add_child(contents_root)

	var tray_color = Color(0.38, 0.31, 0.24, 1.0)
	var wall_color = Color(0.48, 0.39, 0.30, 1.0)
	var handle_color = Color(0.18, 0.16, 0.14, 1.0)

	_add_panel("Floor", Vector3(0.0, -FLOOR_THICKNESS * 0.5, 0.0), Vector3(INNER_WIDTH + WALL_THICKNESS * 2.0, FLOOR_THICKNESS, INNER_DEPTH + WALL_THICKNESS * 2.0), tray_color)
	_add_panel("LeftWall", Vector3(-INNER_WIDTH * 0.5 - WALL_THICKNESS * 0.5, WALL_HEIGHT * 0.5, 0.0), Vector3(WALL_THICKNESS, WALL_HEIGHT, INNER_DEPTH + WALL_THICKNESS * 2.0), wall_color)
	_add_panel("RightWall", Vector3(INNER_WIDTH * 0.5 + WALL_THICKNESS * 0.5, WALL_HEIGHT * 0.5, 0.0), Vector3(WALL_THICKNESS, WALL_HEIGHT, INNER_DEPTH + WALL_THICKNESS * 2.0), wall_color)
	_add_panel("BackWall", Vector3(0.0, WALL_HEIGHT * 0.5, -INNER_DEPTH * 0.5 - WALL_THICKNESS * 0.5), Vector3(INNER_WIDTH + WALL_THICKNESS * 2.0, WALL_HEIGHT, WALL_THICKNESS), wall_color)
	_add_panel("FrontLip", Vector3(0.0, WALL_HEIGHT * 0.32, INNER_DEPTH * 0.5 + WALL_THICKNESS * 0.5), Vector3(INNER_WIDTH + WALL_THICKNESS * 2.0, WALL_HEIGHT * 0.64, WALL_THICKNESS), wall_color)

	_handle_mesh = _add_panel("Handle", Vector3(0.0, WALL_HEIGHT * 0.45, INNER_DEPTH * 0.5 + WALL_THICKNESS + 0.018), Vector3(0.11, 0.024, 0.026), handle_color)

	_selection_mesh = MeshInstance3D.new()
	_selection_mesh.name = "SelectionHint"
	var selection_box = BoxMesh.new()
	selection_box.size = Vector3(INNER_WIDTH + 0.05, WALL_HEIGHT + 0.035, INNER_DEPTH + 0.07)
	_selection_mesh.mesh = selection_box
	_selection_mesh.position.y = WALL_HEIGHT * 0.35
	_selection_mesh.material_override = _selection_material()
	_selection_mesh.visible = false
	_selection_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	visual_root.add_child(_selection_mesh)


func get_interaction_type() -> String:
	return "drawer"


func set_selected(selected: bool) -> void:
	if _selection_mesh != null:
		_selection_mesh.visible = selected


func set_open_amount(value: float) -> void:
	open_amount = clamp(value, 0.0, 1.0)
	position = closed_position + Vector3(0.0, 0.0, open_amount * max_pull_distance)


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
	return abs(local.x) <= INNER_WIDTH * 0.5 + 0.04 \
		and local.z >= -INNER_DEPTH * 0.5 - 0.04 \
		and local.z <= INNER_DEPTH * 0.5 + 0.04 \
		and local.y >= -0.03 \
		and local.y <= WALL_HEIGHT + 0.13


func add_item(item: Node) -> void:
	var item_count = _count_card_like_children(item)
	item.reparent(contents_root, true)
	item.area_id = drawer_id
	item.position = _storage_position(item_count)
	item.align_for_storage()
	item.end_drag()


func get_saved_open_amount() -> float:
	return open_amount


func _storage_position(index: int) -> Vector3:
	var z_offset = -INNER_DEPTH * 0.30 + min(index, 14) * 0.014
	var y_offset = CARD_THICKNESS * 0.5 + index * 0.0017
	return Vector3(0.0, y_offset, z_offset)


func _count_card_like_children(excluding: Node) -> int:
	var count = 0
	for child in contents_root.get_children():
		if child != excluding and _is_card_like(child):
			count += 1
	return count


func _is_card_like(node: Node) -> bool:
	if node == null or not node.has_method("get_interaction_type"):
		return false
	var interaction_type = node.get_interaction_type()
	return interaction_type == "card" or interaction_type == "divider"


func _add_panel(panel_name: String, panel_position: Vector3, panel_size: Vector3, color: Color) -> MeshInstance3D:
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.name = panel_name
	var box = BoxMesh.new()
	box.size = panel_size
	mesh_instance.mesh = box
	mesh_instance.position = panel_position
	mesh_instance.material_override = _material(color)
	visual_root.add_child(mesh_instance)

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
	mat.roughness = 0.86
	return mat


func _selection_material() -> StandardMaterial3D:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.2, 0.75, 1.0, 0.22)
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	return mat

