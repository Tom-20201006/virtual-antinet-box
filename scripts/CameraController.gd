extends Node3D
class_name CameraController

var camera: Camera3D
var target = Vector3.ZERO
var yaw = deg_to_rad(35.0)
var pitch = deg_to_rad(58.0)
var distance = 1.45
var orbiting = false
var panning = false


func _ready() -> void:
	camera = Camera3D.new()
	camera.name = "Camera3D"
	camera.current = true
	camera.fov = 48.0
	add_child(camera)
	_apply_camera_transform()


func get_camera() -> Camera3D:
	return camera


func set_overview() -> void:
	target = Vector3(0.0, 0.04, 0.0)
	yaw = deg_to_rad(35.0)
	pitch = deg_to_rad(58.0)
	distance = 1.45
	_apply_camera_transform()


func set_drawer_view(drawer_position: Vector3) -> void:
	target = drawer_position + Vector3(0.0, 0.08, 0.02)
	yaw = deg_to_rad(8.0)
	pitch = deg_to_rad(42.0)
	distance = 0.68
	_apply_camera_transform()


func focus_on(node: Node3D) -> void:
	target = node.global_position
	distance = 0.34 if _is_card_like(node) else 0.62
	pitch = deg_to_rad(63.0)
	_apply_camera_transform()


func _is_card_like(node: Node) -> bool:
	if node == null or not node.has_method("get_interaction_type"):
		return false
	var interaction_type = node.get_interaction_type()
	return interaction_type == "card" or interaction_type == "divider"


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			orbiting = event.pressed
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			panning = event.pressed
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			distance = max(distance * 0.90, 0.18)
			_apply_camera_transform()
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			distance = min(distance * 1.10, 3.0)
			_apply_camera_transform()
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseMotion:
		if orbiting:
			yaw -= event.relative.x * 0.006
			pitch = clamp(pitch - event.relative.y * 0.0045, deg_to_rad(20.0), deg_to_rad(82.0))
			_apply_camera_transform()
			get_viewport().set_input_as_handled()
		elif panning:
			var right = camera.global_transform.basis.x
			var up = camera.global_transform.basis.y
			target += (-right * event.relative.x + up * event.relative.y) * distance * 0.0012
			_apply_camera_transform()
			get_viewport().set_input_as_handled()


func _apply_camera_transform() -> void:
	if camera == null:
		return
	var horizontal = distance * cos(pitch)
	var offset = Vector3(sin(yaw) * horizontal, sin(pitch) * distance, cos(yaw) * horizontal)
	camera.global_position = target + offset
	camera.look_at(target, Vector3.UP)

