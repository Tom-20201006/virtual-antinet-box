extends Node3D

const DESK_SIZE := Vector3(1.65, 0.06, 1.05)
const DESK_TOP_Y := DESK_SIZE.y * 0.5
const DRAG_LIFT_HEIGHT := 0.075

const CardScript := preload("res://scripts/Card.gd")
const DividerScript := preload("res://scripts/Divider.gd")
const CardBoxScript := preload("res://scripts/CardBox.gd")
const CameraControllerScript := preload("res://scripts/CameraController.gd")
const InteractionControllerScript := preload("res://scripts/InteractionController.gd")
const CardImporterScript := preload("res://scripts/CardImporter.gd")
const WorldStateScript := preload("res://scripts/WorldState.gd")
const PhysicsSleepManagerScript := preload("res://scripts/PhysicsSleepManager.gd")

var cards_root: Node3D
var card_box: Node
var camera_controller: Node
var interaction_controller: Node
var importer: Node
var world_state: Node
var physics_sleep_manager: Node
var status_label: Label
var file_dialog: FileDialog
var _next_card_number = 1
var _next_divider_number = 1


func _ready() -> void:
	_ensure_runtime_dirs()
	_build_environment()
	_build_ui()
	_build_controllers()
	if not load_world(false):
		_spawn_default_demo_contents()
	update_status("Ready")


func get_drag_plane_y() -> float:
	return DESK_TOP_Y


func get_drag_lift_height() -> float:
	return DRAG_LIFT_HEIGHT


func begin_drag_object(object: Node) -> void:
	if object == null:
		return
	if object.get_parent() != cards_root:
		object.reparent(cards_root, true)
	object.area_id = "desk"
	object.begin_drag()
	physics_sleep_manager.mark_active(object)
	physics_sleep_manager.freeze_all_idle(object)


func drop_interactive_object(object: Node) -> void:
	if object == null:
		return
	var drawer = _drawer_under_point(object.global_position)
	if drawer != null:
		drawer.add_item(object)
		update_status("%s placed in %s" % [object.object_id, drawer.drawer_id])
	else:
		if object.get_parent() != cards_root:
			object.reparent(cards_root, true)
		object.area_id = "desk"
		var position = object.global_position
		position.y = DESK_TOP_Y + object.card_size.y * 0.5 + _desk_stack_offset(object, position)
		object.global_position = position
		object.end_drag()
		update_status("%s placed on desk" % object.object_id)
	physics_sleep_manager.mark_sleeping(object)


func create_imported_card(front_path: String):
	var card = create_card(front_path, "", "")
	card.global_position = Vector3(0.55, DESK_TOP_Y + card.card_size.y * 0.5, 0.26)
	card.area_id = "import_area"
	interaction_controller.select_object(card)
	update_status("Imported card created")
	return card


func create_card(front_path: String = "", back_path: String = "", requested_id: String = ""):
	var card = CardScript.new()
	card.object_id = requested_id if not requested_id.is_empty() else "card_%03d" % _next_card_number
	_next_card_number += 1
	card.name = card.object_id
	card.front_image_path = front_path
	card.back_image_path = back_path
	cards_root.add_child(card)
	physics_sleep_manager.register_interactive(card)
	return card


func create_divider(requested_id: String = ""):
	var divider = DividerScript.new()
	divider.object_id = requested_id if not requested_id.is_empty() else "divider_%03d" % _next_divider_number
	_next_divider_number += 1
	divider.name = divider.object_id
	cards_root.add_child(divider)
	physics_sleep_manager.register_interactive(divider)
	return divider


func open_import_dialog() -> void:
	importer.open_import_dialog()


func save_world() -> bool:
	var ok = world_state.save_world(self)
	update_status("World saved: %s" % world_state.get_save_path() if ok else "Save failed")
	return ok


func load_world(show_status: bool = true) -> bool:
	var ok = world_state.load_world(self)
	if show_status:
		update_status("World loaded" if ok else "No saved world state found")
	return ok


func update_status(message: String) -> void:
	if status_label != null:
		status_label.text = message


func update_status_for_selection(object: Node) -> void:
	if object == null:
		update_status("Selected: none")
	elif _is_drawer(object):
		update_status("Selected: %s  open %.0f%%" % [object.drawer_id, object.open_amount * 100.0])
	elif _is_card_like(object):
		update_status("Selected: %s  area %s" % [object.object_id, object.area_id])
	else:
		update_status("Selected: %s" % object.name)


func set_camera_view(view_name: String) -> void:
	match view_name:
		"overview":
			camera_controller.set_overview()
		"drawer":
			if _is_drawer(interaction_controller.selected_object):
				camera_controller.set_drawer_view(interaction_controller.selected_object.global_position)
			elif card_box.drawers.size() > 0:
				camera_controller.set_drawer_view(card_box.drawers[0].global_position)
		"focus":
			if interaction_controller.selected_object is Node3D:
				camera_controller.focus_on(interaction_controller.selected_object)
			else:
				camera_controller.set_overview()


func get_world_state_data() -> Dictionary:
	var card_states: Array = []
	for card in _get_all_card_like_nodes():
		card_states.append(card.to_state())
	var drawer_states: Array = []
	for drawer in card_box.drawers:
		drawer_states.append({
			"id": drawer.drawer_id,
			"open_amount": drawer.get_saved_open_amount()
		})
	return {
		"version": 1,
		"principle": "physical_state_and_resource_paths_only",
		"cards": card_states,
		"drawers": drawer_states
	}


func apply_world_state_data(data: Dictionary) -> void:
	_clear_card_like_nodes()
	for drawer_data in data.get("drawers", []):
		var drawer = card_box.get_drawer_by_id(str(drawer_data.get("id", "")))
		if drawer != null:
			drawer.set_open_amount(float(drawer_data.get("open_amount", 0.0)))
	for card_data in data.get("cards", []):
		var kind = str(card_data.get("kind", "card"))
		var item
		if kind == "divider":
			item = create_divider(str(card_data.get("id", "")))
		else:
			item = create_card(str(card_data.get("front_image_path", "")), str(card_data.get("back_image_path", "")), str(card_data.get("id", "")))
		item.apply_state(card_data)
		var saved_position = _array_to_vector(card_data.get("position", []), item.global_position)
		var saved_rotation = _array_to_vector(card_data.get("rotation", []), item.rotation)
		item.global_position = saved_position
		item.global_transform.basis = Basis.from_euler(saved_rotation)
		var area = str(card_data.get("area_id", "desk"))
		var drawer = card_box.get_drawer_by_id(area)
		if drawer != null:
			item.reparent(drawer.contents_root, true)
			item.area_id = area
	update_status("Loaded %d items" % _get_all_card_like_nodes().size())


func _ensure_runtime_dirs() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("user://imported_cards"))


func _build_environment() -> void:
	var world_environment = WorldEnvironment.new()
	world_environment.name = "WorldEnvironment"
	var environment = Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color(0.63, 0.68, 0.72, 1.0)
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.85, 0.86, 0.88, 1.0)
	environment.ambient_light_energy = 0.75
	world_environment.environment = environment
	add_child(world_environment)

	var light = DirectionalLight3D.new()
	light.name = "DirectionalLight3D"
	light.rotation_degrees = Vector3(-55.0, 35.0, 0.0)
	light.light_energy = 2.0
	add_child(light)

	_build_desk()

	cards_root = Node3D.new()
	cards_root.name = "CardsRoot"
	add_child(cards_root)

	card_box = CardBoxScript.new()
	card_box.name = "CardBox"
	card_box.position = Vector3(-0.45, DESK_TOP_Y, -0.08)
	add_child(card_box)


func _build_desk() -> void:
	var desk = Node3D.new()
	desk.name = "Desk"
	add_child(desk)
	_add_box(desk, "DeskTop", Vector3.ZERO, DESK_SIZE, Color(0.55, 0.48, 0.39, 1.0), true)
	_add_zone(desk, "CardBoxZone", Vector3(-0.45, DESK_TOP_Y + 0.0015, -0.08), Vector2(0.48, 0.48), Color(0.16, 0.28, 0.44, 0.30))
	_add_zone(desk, "WorkSpreadZone", Vector3(0.20, DESK_TOP_Y + 0.0018, -0.10), Vector2(0.62, 0.58), Color(0.18, 0.48, 0.30, 0.24))
	_add_zone(desk, "ImportLandingZone", Vector3(0.55, DESK_TOP_Y + 0.002, 0.27), Vector2(0.32, 0.25), Color(0.62, 0.46, 0.16, 0.26))


func _build_ui() -> void:
	var ui = CanvasLayer.new()
	ui.name = "UI"
	add_child(ui)

	var panel = PanelContainer.new()
	panel.name = "StatusPanel"
	panel.offset_left = 12.0
	panel.offset_top = 12.0
	panel.offset_right = 510.0
	panel.offset_bottom = 86.0
	ui.add_child(panel)

	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_bottom", 6)
	panel.add_child(margin)

	var rows = VBoxContainer.new()
	margin.add_child(rows)

	var buttons = HBoxContainer.new()
	rows.add_child(buttons)
	_add_button(buttons, "瀵煎叆", _on_import_pressed)
	_add_button(buttons, "淇濆瓨", _on_save_pressed)
	_add_button(buttons, "杞藉叆", _on_load_pressed)
	_add_button(buttons, "鎬昏", _on_overview_pressed)
	_add_button(buttons, "鎶藉眽", _on_drawer_view_pressed)
	_add_button(buttons, "鑱氱劍", _on_focus_pressed)

	status_label = Label.new()
	status_label.name = "StatusLabel"
	status_label.text = "Ready"
	rows.add_child(status_label)

	file_dialog = FileDialog.new()
	file_dialog.name = "ImportImageDialog"
	file_dialog.title = "Import card front image"
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.filters = PackedStringArray(["*.png, *.jpg, *.jpeg, *.webp ; Image files"])
	ui.add_child(file_dialog)


func _build_controllers() -> void:
	world_state = WorldStateScript.new()
	world_state.name = "WorldState"
	add_child(world_state)

	physics_sleep_manager = PhysicsSleepManagerScript.new()
	physics_sleep_manager.name = "PhysicsSleepManager"
	add_child(physics_sleep_manager)

	camera_controller = CameraControllerScript.new()
	camera_controller.name = "CameraController"
	add_child(camera_controller)

	interaction_controller = InteractionControllerScript.new()
	interaction_controller.name = "InteractionController"
	add_child(interaction_controller)
	interaction_controller.setup(self, camera_controller)

	importer = CardImporterScript.new()
	importer.name = "CardImporter"
	add_child(importer)
	importer.setup(self, file_dialog)


func _spawn_default_demo_contents() -> void:
	card_box.drawers[0].set_open_amount(0.68)
	card_box.drawers[1].set_open_amount(0.30)
	card_box.drawers[2].set_open_amount(0.0)

	var first = create_card()
	first.global_position = Vector3(0.22, DESK_TOP_Y + first.card_size.y * 0.5, -0.26)
	first.rotation_degrees.y = -8.0

	var second = create_card()
	card_box.drawers[0].add_item(second)

	var third = create_card()
	card_box.drawers[0].add_item(third)

	var divider = create_divider()
	card_box.drawers[1].add_item(divider)


func _drawer_under_point(point: Vector3):
	for drawer in card_box.drawers:
		if drawer.contains_world_point(point):
			return drawer
	return null


func _desk_stack_offset(item: Node, position: Vector3) -> float:
	var stack_count = 0
	for other in cards_root.get_children():
		if other != item and _is_card_like(other) and other.global_position.distance_to(position) < 0.035:
			stack_count += 1
	return min(stack_count, 10) * 0.003


func _get_all_card_like_nodes() -> Array:
	var result: Array = []
	_collect_card_like(cards_root, result)
	for drawer in card_box.drawers:
		_collect_card_like(drawer.contents_root, result)
	return result


func _collect_card_like(root: Node, result: Array) -> void:
	for child in root.get_children():
		if _is_card_like(child):
			result.append(child)
		_collect_card_like(child, result)


func _is_card_like(node: Node) -> bool:
	if node == null or not node.has_method("get_interaction_type"):
		return false
	var interaction_type = node.get_interaction_type()
	return interaction_type == "card" or interaction_type == "divider"


func _is_drawer(node: Node) -> bool:
	return node != null and node.has_method("get_interaction_type") and node.get_interaction_type() == "drawer"


func _clear_card_like_nodes() -> void:
	for item in _get_all_card_like_nodes():
		if item.get_parent() != null:
			item.get_parent().remove_child(item)
		item.queue_free()
	physics_sleep_manager.registered_objects.clear()


func _add_box(parent: Node, box_name: String, box_position: Vector3, box_size: Vector3, color: Color, collision: bool) -> MeshInstance3D:
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.name = box_name
	var box = BoxMesh.new()
	box.size = box_size
	mesh_instance.mesh = box
	mesh_instance.position = box_position
	mesh_instance.material_override = _material(color)
	parent.add_child(mesh_instance)
	if collision:
		var body = StaticBody3D.new()
		body.name = "%sCollision" % box_name
		body.position = box_position
		var shape = CollisionShape3D.new()
		var box_shape = BoxShape3D.new()
		box_shape.size = box_size
		shape.shape = box_shape
		body.add_child(shape)
		parent.add_child(body)
	return mesh_instance


func _add_zone(parent: Node, zone_name: String, zone_position: Vector3, zone_size: Vector2, color: Color) -> void:
	var zone = MeshInstance3D.new()
	zone.name = zone_name
	var plane = PlaneMesh.new()
	plane.size = zone_size
	zone.mesh = plane
	zone.position = zone_position
	zone.material_override = _transparent_material(color)
	zone.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	parent.add_child(zone)


func _add_button(parent: Node, label: String, callback: Callable) -> void:
	var button = Button.new()
	button.text = label
	button.pressed.connect(callback)
	parent.add_child(button)


func _material(color: Color) -> StandardMaterial3D:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.86
	return mat


func _transparent_material(color: Color) -> StandardMaterial3D:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	return mat


func _array_to_vector(value: Variant, fallback: Vector3) -> Vector3:
	if typeof(value) != TYPE_ARRAY or value.size() < 3:
		return fallback
	return Vector3(float(value[0]), float(value[1]), float(value[2]))


func _on_import_pressed() -> void:
	open_import_dialog()


func _on_save_pressed() -> void:
	save_world()


func _on_load_pressed() -> void:
	load_world()


func _on_overview_pressed() -> void:
	set_camera_view("overview")


func _on_drawer_view_pressed() -> void:
	set_camera_view("drawer")


func _on_focus_pressed() -> void:
	set_camera_view("focus")

