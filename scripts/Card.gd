extends Node3D
class_name Card

const CARD_WIDTH := 0.1524
const CARD_DEPTH := 0.1016
const CARD_THICKNESS := 0.0024

var object_id = ""
var object_kind = "card"
var front_image_path = ""
var back_image_path = ""
var area_id = "desk"
var face_down = false
var is_sleeping = true
var uses_placeholder_texture = true
var card_size = Vector3(CARD_WIDTH, CARD_THICKNESS, CARD_DEPTH)
var front_color = Color(0.96, 0.94, 0.86, 1.0)
var back_color = Color(0.94, 0.92, 0.84, 1.0)
var edge_color = Color(0.74, 0.69, 0.58, 1.0)
var physical_profile = "plain_paper"
var has_ruled_lines = false
var has_tab = false
var tab_label = ""
var has_ink_marks = true
var drawer_slot_index = -1

var visual_root: Node3D
var collision_root: Node3D
var _body_mesh: MeshInstance3D
var _front_mesh: MeshInstance3D
var _back_mesh: MeshInstance3D
var _selection_mesh: MeshInstance3D


func _ready() -> void:
	if visual_root == null:
		build()


func build() -> void:
	if visual_root != null:
		return

	visual_root = Node3D.new()
	visual_root.name = "VisualRoot"
	add_child(visual_root)

	collision_root = Node3D.new()
	collision_root.name = "CollisionRoot"
	add_child(collision_root)

	_body_mesh = MeshInstance3D.new()
	_body_mesh.name = "VisiblePaperEdge"
	var body_mesh = BoxMesh.new()
	body_mesh.size = card_size
	_body_mesh.mesh = body_mesh
	_body_mesh.material_override = _make_material(edge_color, 0.92)
	visual_root.add_child(_body_mesh)

	_front_mesh = MeshInstance3D.new()
	_front_mesh.name = "FrontPaperSurface"
	var front_plane = PlaneMesh.new()
	front_plane.size = Vector2(card_size.x, card_size.z)
	_front_mesh.mesh = front_plane
	_front_mesh.position.y = card_size.y * 0.62
	_front_mesh.material_override = _make_surface_material(front_color, front_image_path, true)
	visual_root.add_child(_front_mesh)

	_back_mesh = MeshInstance3D.new()
	_back_mesh.name = "BackPaperSurface"
	var back_plane = PlaneMesh.new()
	back_plane.size = Vector2(card_size.x, card_size.z)
	_back_mesh.mesh = back_plane
	_back_mesh.position.y = -card_size.y * 0.62
	_back_mesh.rotation_degrees.x = 180.0
	_back_mesh.material_override = _make_surface_material(back_color, back_image_path, false)
	visual_root.add_child(_back_mesh)

	_build_paper_marks()
	if has_tab:
		_build_tab()

	_selection_mesh = MeshInstance3D.new()
	_selection_mesh.name = "SelectionHint"
	var selection_mesh = BoxMesh.new()
	selection_mesh.size = Vector3(card_size.x + 0.016, max(card_size.y, 0.006), card_size.z + (0.030 if has_tab else 0.016))
	_selection_mesh.mesh = selection_mesh
	_selection_mesh.position.y = 0.004
	_selection_mesh.material_override = _make_selection_material()
	_selection_mesh.visible = false
	_selection_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	visual_root.add_child(_selection_mesh)

	var body = StaticBody3D.new()
	body.name = "CardCollisionBody"
	body.collision_layer = 1
	body.collision_mask = 1
	var shape = CollisionShape3D.new()
	var box_shape = BoxShape3D.new()
	box_shape.size = Vector3(card_size.x, max(card_size.y, 0.012), card_size.z + (0.018 if has_tab else 0.0))
	shape.shape = box_shape
	body.add_child(shape)
	collision_root.add_child(body)


func apply_physical_profile(profile: String) -> void:
	physical_profile = profile
	match physical_profile:
		"ruled_paper":
			front_color = Color(0.96, 0.95, 0.88, 1.0)
			back_color = Color(0.94, 0.93, 0.86, 1.0)
			edge_color = Color(0.72, 0.68, 0.58, 1.0)
			card_size = Vector3(CARD_WIDTH, CARD_THICKNESS, CARD_DEPTH)
			has_ruled_lines = true
			has_ink_marks = true
			has_tab = false
		"colored_paper":
			front_color = Color(0.82, 0.90, 0.78, 1.0)
			back_color = Color(0.76, 0.86, 0.72, 1.0)
			edge_color = Color(0.55, 0.68, 0.50, 1.0)
			card_size = Vector3(CARD_WIDTH, CARD_THICKNESS * 1.1, CARD_DEPTH)
			has_ruled_lines = true
			has_ink_marks = true
			has_tab = false
		"thin_plain_paper":
			front_color = Color(0.98, 0.97, 0.91, 1.0)
			back_color = Color(0.96, 0.95, 0.88, 1.0)
			edge_color = Color(0.78, 0.74, 0.64, 1.0)
			card_size = Vector3(CARD_WIDTH, CARD_THICKNESS * 0.85, CARD_DEPTH)
			has_ruled_lines = false
			has_ink_marks = true
			has_tab = false
		"divider_tab":
			front_color = Color(0.42, 0.66, 0.78, 1.0)
			back_color = Color(0.36, 0.58, 0.70, 1.0)
			edge_color = Color(0.19, 0.35, 0.43, 1.0)
			card_size = Vector3(CARD_WIDTH, CARD_THICKNESS * 1.35, CARD_DEPTH * 1.18)
			has_ruled_lines = false
			has_ink_marks = false
			has_tab = true
			if tab_label.is_empty():
				tab_label = "A"
		_:
			physical_profile = "plain_paper"
			front_color = Color(0.96, 0.94, 0.86, 1.0)
			back_color = Color(0.94, 0.92, 0.84, 1.0)
			edge_color = Color(0.74, 0.69, 0.58, 1.0)
			card_size = Vector3(CARD_WIDTH, CARD_THICKNESS, CARD_DEPTH)
			has_ruled_lines = false
			has_ink_marks = true
			has_tab = false
	if visual_root != null:
		_rebuild_visuals()


func get_interaction_type() -> String:
	return object_kind


func set_selected(selected: bool) -> void:
	if _selection_mesh == null:
		return
	_selection_mesh.visible = selected


func begin_drag() -> void:
	set_sleeping_state(false)


func end_drag() -> void:
	set_sleeping_state(true)


func set_drag_position(world_position: Vector3) -> void:
	global_position = world_position


func rotate_flat(angle_radians: float) -> void:
	global_rotate(Vector3.UP, angle_radians)


func flip_card() -> void:
	face_down = not face_down
	rotate_object_local(Vector3.RIGHT, PI)


func align_for_desk() -> void:
	drawer_slot_index = -1
	rotation.x = PI if face_down else 0.0
	rotation.z = 0.0


func align_for_storage(slot_index: int = 0) -> void:
	drawer_slot_index = slot_index
	var tilt = deg_to_rad(float((slot_index % 3) - 1) * 1.6)
	rotation = Vector3(-PI * 0.5 + (PI if face_down else 0.0) + tilt, 0.0, 0.0)


func set_sleeping_state(sleeping: bool) -> void:
	is_sleeping = sleeping


func set_front_image(path: String) -> void:
	front_image_path = path
	if _front_mesh != null:
		_front_mesh.material_override = _make_surface_material(front_color, front_image_path, true)


func set_back_image(path: String) -> void:
	back_image_path = path
	if _back_mesh != null:
		_back_mesh.material_override = _make_surface_material(back_color, back_image_path, false)


func to_state() -> Dictionary:
	return {
		"id": object_id,
		"kind": object_kind,
		"front_image_path": front_image_path,
		"back_image_path": back_image_path,
		"area_id": area_id,
		"position": _vector_to_array(global_position),
		"rotation": _vector_to_array(global_transform.basis.get_euler()),
		"face_down": face_down,
		"size": _vector_to_array(card_size),
		"sleeping": is_sleeping,
		"physical_profile": physical_profile,
		"has_ruled_lines": has_ruled_lines,
		"has_tab": has_tab,
		"tab_label": tab_label,
		"has_ink_marks": has_ink_marks,
		"front_color": _color_to_array(front_color),
		"back_color": _color_to_array(back_color),
		"edge_color": _color_to_array(edge_color),
		"drawer_slot_index": drawer_slot_index
	}


func apply_state(data: Dictionary) -> void:
	object_id = str(data.get("id", object_id))
	object_kind = str(data.get("kind", object_kind))
	front_image_path = str(data.get("front_image_path", ""))
	back_image_path = str(data.get("back_image_path", ""))
	area_id = str(data.get("area_id", "desk"))
	face_down = bool(data.get("face_down", false))
	is_sleeping = bool(data.get("sleeping", true))
	tab_label = str(data.get("tab_label", tab_label))
	apply_physical_profile(str(data.get("physical_profile", physical_profile)))
	has_ruled_lines = bool(data.get("has_ruled_lines", has_ruled_lines))
	has_tab = bool(data.get("has_tab", has_tab))
	has_ink_marks = bool(data.get("has_ink_marks", has_ink_marks))
	if data.has("size"):
		card_size = _array_to_vector(data["size"], card_size)
	front_color = _array_to_color(data.get("front_color", []), front_color)
	back_color = _array_to_color(data.get("back_color", []), back_color)
	edge_color = _array_to_color(data.get("edge_color", []), edge_color)
	drawer_slot_index = int(data.get("drawer_slot_index", drawer_slot_index))
	if visual_root == null:
		build()
	else:
		_rebuild_visuals()
	set_front_image(front_image_path)
	set_back_image(back_image_path)


func _build_paper_marks() -> void:
	var y = card_size.y * 0.66
	_add_surface_plane("AddressSlot", Vector3(-card_size.x * 0.31, y + 0.0002, -card_size.z * 0.32), Vector2(card_size.x * 0.30, 0.010), Color(0.12, 0.13, 0.12, 0.28))
	_add_surface_plane("FixedNumberLine", Vector3(-card_size.x * 0.31, y + 0.0004, -card_size.z * 0.39), Vector2(card_size.x * 0.22, 0.002), Color(0.05, 0.05, 0.05, 0.55))

	if has_ruled_lines:
		for index in range(6):
			var z = -card_size.z * 0.20 + index * card_size.z * 0.105
			_add_surface_plane("RuledLine%d" % index, Vector3(0.0, y + 0.0005 + index * 0.00001, z), Vector2(card_size.x * 0.82, 0.0014), Color(0.16, 0.28, 0.55, 0.30))

	if has_ink_marks:
		_add_surface_plane("BlackInkStrokeA", Vector3(0.010, y + 0.0008, -card_size.z * 0.08), Vector2(card_size.x * 0.48, 0.003), Color(0.02, 0.02, 0.02, 0.76))
		_add_surface_plane("BlackInkStrokeB", Vector3(-0.004, y + 0.0010, card_size.z * 0.04), Vector2(card_size.x * 0.56, 0.0026), Color(0.02, 0.02, 0.02, 0.64))
		_add_surface_plane("GreenLinkMark", Vector3(card_size.x * 0.22, y + 0.0012, card_size.z * 0.20), Vector2(card_size.x * 0.23, 0.003), Color(0.00, 0.45, 0.20, 0.70))
		_add_surface_plane("RedReferenceMark", Vector3(-card_size.x * 0.22, y + 0.0014, card_size.z * 0.30), Vector2(card_size.x * 0.18, 0.003), Color(0.76, 0.10, 0.08, 0.70))


func _build_tab() -> void:
	var tab = MeshInstance3D.new()
	tab.name = "RaisedTab"
	var tab_mesh = BoxMesh.new()
	tab_mesh.size = Vector3(card_size.x * 0.30, card_size.y * 1.4, card_size.z * 0.15)
	tab.mesh = tab_mesh
	tab.position = Vector3(card_size.x * 0.20, card_size.y * 0.70, card_size.z * 0.55)
	tab.material_override = _make_material(front_color.lightened(0.10), 0.88)
	visual_root.add_child(tab)
	_add_surface_plane("TabLabelPlaceholder", Vector3(card_size.x * 0.20, card_size.y * 1.55, card_size.z * 0.55), Vector2(card_size.x * 0.18, 0.006), Color(0.04, 0.05, 0.05, 0.60))


func _add_surface_plane(plane_name: String, plane_position: Vector3, plane_size: Vector2, color: Color) -> MeshInstance3D:
	var plane_instance = MeshInstance3D.new()
	plane_instance.name = plane_name
	var plane = PlaneMesh.new()
	plane.size = plane_size
	plane_instance.mesh = plane
	plane_instance.position = plane_position
	plane_instance.material_override = _make_transparent_material(color)
	plane_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	visual_root.add_child(plane_instance)
	return plane_instance


func _make_surface_material(color: Color, texture_path: String, allow_placeholder: bool) -> StandardMaterial3D:
	var mat = _make_material(color, 0.90)
	var texture = _load_texture(texture_path)
	if texture == null and allow_placeholder and uses_placeholder_texture:
		texture = _make_placeholder_texture(color)
	if texture != null:
		mat.albedo_texture = texture
	return mat


func _make_material(color: Color, roughness: float = 0.82) -> StandardMaterial3D:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = roughness
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	return mat


func _make_transparent_material(color: Color) -> StandardMaterial3D:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.90
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	return mat


func _make_selection_material() -> StandardMaterial3D:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(1.0, 0.82, 0.08, 0.34)
	mat.emission_enabled = true
	mat.emission = Color(1.0, 0.72, 0.02, 1.0)
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	return mat


func _load_texture(path: String) -> Texture2D:
	if path.is_empty():
		return null
	if ResourceLoader.exists(path):
		return load(path)
	var image = Image.new()
	if image.load(path) != OK:
		return null
	return ImageTexture.create_from_image(image)


func _make_placeholder_texture(base_color: Color) -> Texture2D:
	var image = Image.create(360, 240, false, Image.FORMAT_RGBA8)
	image.fill(base_color)
	var border = Color(0.22, 0.20, 0.16, 1.0)
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			if x < 5 or x > image.get_width() - 6 or y < 5 or y > image.get_height() - 6:
				image.set_pixel(x, y, border)
			elif (x * 3 + y * 5) % 67 < 3:
				image.set_pixel(x, y, base_color.darkened(0.055))
			elif (x + y) % 113 < 2:
				image.set_pixel(x, y, base_color.lightened(0.035))
	return ImageTexture.create_from_image(image)


func _rebuild_visuals() -> void:
	if visual_root != null:
		remove_child(visual_root)
		visual_root.queue_free()
		visual_root = null
	if collision_root != null:
		remove_child(collision_root)
		collision_root.queue_free()
		collision_root = null
	build()


func _vector_to_array(value: Vector3) -> Array:
	return [value.x, value.y, value.z]


func _color_to_array(value: Color) -> Array:
	return [value.r, value.g, value.b, value.a]


func _array_to_vector(value: Variant, fallback: Vector3) -> Vector3:
	if typeof(value) != TYPE_ARRAY or value.size() < 3:
		return fallback
	return Vector3(float(value[0]), float(value[1]), float(value[2]))


func _array_to_color(value: Variant, fallback: Color) -> Color:
	if typeof(value) != TYPE_ARRAY or value.size() < 3:
		return fallback
	var alpha = float(value[3]) if value.size() > 3 else fallback.a
	return Color(float(value[0]), float(value[1]), float(value[2]), alpha)
