extends Node3D
class_name Card

const CARD_WIDTH := 0.1524
const CARD_DEPTH := 0.1016
const CARD_THICKNESS := 0.0015

var object_id = ""
var object_kind = "card"
var front_image_path = ""
var back_image_path = ""
var area_id = "desk"
var face_down = false
var is_sleeping = true
var uses_placeholder_texture = true
var card_size = Vector3(CARD_WIDTH, CARD_THICKNESS, CARD_DEPTH)
var front_color = Color(0.88, 0.92, 0.96, 1.0)
var back_color = Color(0.98, 0.96, 0.88, 1.0)
var edge_color = Color(0.78, 0.74, 0.66, 1.0)

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
	_body_mesh.name = "CardBody"
	var body_mesh = BoxMesh.new()
	body_mesh.size = card_size
	_body_mesh.mesh = body_mesh
	_body_mesh.material_override = _make_material(edge_color)
	visual_root.add_child(_body_mesh)

	_front_mesh = MeshInstance3D.new()
	_front_mesh.name = "FrontSurface"
	var front_plane = PlaneMesh.new()
	front_plane.size = Vector2(card_size.x, card_size.z)
	_front_mesh.mesh = front_plane
	_front_mesh.position.y = card_size.y * 0.62
	_front_mesh.material_override = _make_surface_material(front_color, front_image_path, true)
	visual_root.add_child(_front_mesh)

	_back_mesh = MeshInstance3D.new()
	_back_mesh.name = "BackSurface"
	var back_plane = PlaneMesh.new()
	back_plane.size = Vector2(card_size.x, card_size.z)
	_back_mesh.mesh = back_plane
	_back_mesh.position.y = -card_size.y * 0.62
	_back_mesh.rotation_degrees.x = 180.0
	_back_mesh.material_override = _make_surface_material(back_color, back_image_path, false)
	visual_root.add_child(_back_mesh)

	_selection_mesh = MeshInstance3D.new()
	_selection_mesh.name = "SelectionHint"
	var selection_mesh = BoxMesh.new()
	selection_mesh.size = Vector3(card_size.x + 0.016, max(card_size.y, 0.006), card_size.z + 0.016)
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
	box_shape.size = Vector3(card_size.x, max(card_size.y, 0.012), card_size.z)
	shape.shape = box_shape
	body.add_child(shape)
	collision_root.add_child(body)


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


func align_for_storage() -> void:
	rotation = Vector3(PI if face_down else 0.0, 0.0, 0.0)


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
		"sleeping": is_sleeping
	}


func apply_state(data: Dictionary) -> void:
	object_id = str(data.get("id", object_id))
	object_kind = str(data.get("kind", object_kind))
	front_image_path = str(data.get("front_image_path", ""))
	back_image_path = str(data.get("back_image_path", ""))
	area_id = str(data.get("area_id", "desk"))
	face_down = bool(data.get("face_down", false))
	is_sleeping = bool(data.get("sleeping", true))
	if data.has("size"):
		card_size = _array_to_vector(data["size"], card_size)
	if visual_root == null:
		build()
	set_front_image(front_image_path)
	set_back_image(back_image_path)


func _make_surface_material(color: Color, texture_path: String, allow_placeholder: bool) -> StandardMaterial3D:
	var mat = _make_material(color)
	var texture = _load_texture(texture_path)
	if texture == null and allow_placeholder and uses_placeholder_texture:
		texture = _make_placeholder_texture(color)
	if texture != null:
		mat.albedo_texture = texture
	return mat


func _make_material(color: Color) -> StandardMaterial3D:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.82
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
	var image = Image.create(320, 212, false, Image.FORMAT_RGBA8)
	image.fill(base_color)
	var border = Color(0.15, 0.18, 0.22, 1.0)
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			if x < 6 or x > image.get_width() - 7 or y < 6 or y > image.get_height() - 7:
				image.set_pixel(x, y, border)
			elif (x + y) % 41 < 4:
				image.set_pixel(x, y, base_color.darkened(0.08))
	return ImageTexture.create_from_image(image)


func _vector_to_array(value: Vector3) -> Array:
	return [value.x, value.y, value.z]


func _array_to_vector(value: Variant, fallback: Vector3) -> Vector3:
	if typeof(value) != TYPE_ARRAY or value.size() < 3:
		return fallback
	return Vector3(float(value[0]), float(value[1]), float(value[2]))

