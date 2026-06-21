extends Node
class_name InteractionController

var main: Node
var camera_controller: Node
var selected_object: Node = null
var dragged_object: Node = null
var dragged_drawer: Node = null


func setup(p_main: Node, p_camera_controller: Node) -> void:
	main = p_main
	camera_controller = p_camera_controller


func _unhandled_input(event: InputEvent) -> void:
	if main == null or camera_controller == null:
		return
	if event is InputEventMouseButton:
		_handle_mouse_button(event)
	elif event is InputEventMouseMotion:
		_handle_mouse_motion(event)
	elif event is InputEventKey and event.pressed and not event.echo:
		_handle_key(event)


func select_object(object: Node) -> void:
	if selected_object != null and selected_object.has_method("set_selected"):
		selected_object.set_selected(false)
	selected_object = object
	if selected_object != null and selected_object.has_method("set_selected"):
		selected_object.set_selected(true)
	main.update_status_for_selection(selected_object)


func _handle_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index != MOUSE_BUTTON_LEFT:
		return
	if get_viewport().gui_get_hovered_control() != null:
		return
	if event.pressed:
		var picked = _pick_object(event.position)
		if picked == null:
			select_object(null)
			return
		select_object(picked)
		if _is_card_like(picked):
			dragged_object = picked
			main.begin_drag_object(dragged_object)
		elif _is_drawer(picked):
			dragged_drawer = picked
	else:
		if dragged_object != null:
			main.drop_interactive_object(dragged_object)
			dragged_object = null
		if main != null and main.card_box != null:
			main.card_box.clear_insertion_previews()
		dragged_drawer = null


func _handle_mouse_motion(event: InputEventMouseMotion) -> void:
	if dragged_object != null:
		var plane_point = _mouse_to_plane(event.position, main.get_drag_plane_y())
		if plane_point != null:
			dragged_object.set_drag_position(plane_point + Vector3(0.0, main.get_drag_lift_height(), 0.0))
			main.preview_drawer_insertion(dragged_object.global_position)
			get_viewport().set_input_as_handled()
	elif dragged_drawer != null:
		dragged_drawer.adjust_open_amount(event.relative.y * 0.006)
		main.update_status_for_selection(dragged_drawer)
		get_viewport().set_input_as_handled()


func _handle_key(event: InputEventKey) -> void:
	match event.keycode:
		KEY_Q:
			if _is_card_like(selected_object):
				selected_object.rotate_flat(deg_to_rad(-15.0))
		KEY_E:
			if _is_card_like(selected_object):
				selected_object.rotate_flat(deg_to_rad(15.0))
		KEY_R:
			if _is_card_like(selected_object):
				selected_object.flip_card()
		KEY_O:
			if _is_drawer(selected_object):
				selected_object.toggle_open()
		KEY_I:
			main.open_import_dialog()
		KEY_S:
			if event.ctrl_pressed:
				main.save_world()
		KEY_L:
			if event.ctrl_pressed:
				main.load_world()
		KEY_F5:
			main.save_world()
		KEY_F9:
			main.load_world()
		KEY_1:
			main.set_camera_view("overview")
		KEY_2:
			main.set_camera_view("drawer")
		KEY_3:
			main.set_camera_view("focus")
		KEY_HOME:
			main.set_camera_view("overview")
		KEY_SPACE:
			main.set_camera_view("focus")


func _pick_object(screen_position: Vector2) -> Node:
	var camera = camera_controller.get_camera()
	var from = camera.project_ray_origin(screen_position)
	var to = from + camera.project_ray_normal(screen_position) * 100.0
	var params = PhysicsRayQueryParameters3D.create(from, to)
	params.collide_with_bodies = true
	params.collide_with_areas = true
	var result = main.get_world_3d().direct_space_state.intersect_ray(params)
	if result.is_empty():
		return null
	var collider = result.get("collider") as Node
	return _find_interactive_root(collider)


func _find_interactive_root(node: Node) -> Node:
	var current = node
	while current != null:
		if current.has_method("get_interaction_type"):
			return current
		current = current.get_parent()
	return null


func _is_card_like(node: Node) -> bool:
	if node == null or not node.has_method("get_interaction_type"):
		return false
	var interaction_type = node.get_interaction_type()
	return interaction_type == "card" or interaction_type == "divider"


func _is_drawer(node: Node) -> bool:
	return node != null and node.has_method("get_interaction_type") and node.get_interaction_type() == "drawer"


func _mouse_to_plane(screen_position: Vector2, plane_y: float) -> Variant:
	var camera = camera_controller.get_camera()
	var origin = camera.project_ray_origin(screen_position)
	var direction = camera.project_ray_normal(screen_position)
	if abs(direction.y) < 0.0001:
		return null
	var t = (plane_y - origin.y) / direction.y
	if t < 0.0:
		return null
	return origin + direction * t
