extends Node3D
class_name CardBox

const DrawerScript := preload("res://scripts/Drawer.gd")

var drawers: Array = []
var visual_root: Node3D
var collision_root: Node3D


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

	_build_shell()
	_build_drawers()


func get_drawer_by_id(drawer_id: String) -> Node:
	for drawer in drawers:
		if drawer.drawer_id == drawer_id:
			return drawer
	return null


func clear_insertion_previews() -> void:
	for drawer in drawers:
		if drawer.has_method("clear_insertion_preview"):
			drawer.clear_insertion_preview()


func _build_shell() -> void:
	var shell_color = Color(0.31, 0.24, 0.17, 1.0)
	var darker_wood = Color(0.21, 0.16, 0.11, 1.0)
	var brass = Color(0.82, 0.68, 0.38, 1.0)
	var width = 0.35
	var depth = 0.43
	var height = 0.305
	var side = 0.016
	_add_panel("BottomWoodPanel", Vector3(0.0, side * 0.5, 0.0), Vector3(width, side, depth), shell_color)
	_add_panel("TopWoodPanel", Vector3(0.0, height - side * 0.5, 0.0), Vector3(width, side, depth), shell_color)
	_add_panel("LeftWoodSide", Vector3(-width * 0.5 + side * 0.5, height * 0.5, 0.0), Vector3(side, height, depth), shell_color)
	_add_panel("RightWoodSide", Vector3(width * 0.5 - side * 0.5, height * 0.5, 0.0), Vector3(side, height, depth), shell_color)
	_add_panel("BackWoodPanel", Vector3(0.0, height * 0.5, -depth * 0.5 + side * 0.5), Vector3(width, height, side), shell_color)
	_add_panel("FrontTopRail", Vector3(0.0, height - side * 1.6, depth * 0.5 - side * 0.5), Vector3(width, side * 1.2, side), darker_wood)
	_add_panel("FrontBottomRail", Vector3(0.0, side * 1.6, depth * 0.5 - side * 0.5), Vector3(width, side * 1.2, side), darker_wood)

	for index in range(3):
		var y = 0.043 + index * 0.084
		_add_panel("LeftInternalRail%d" % index, Vector3(-width * 0.5 + side * 1.45, y, 0.020), Vector3(side * 0.45, side * 0.55, depth * 0.78), darker_wood)
		_add_panel("RightInternalRail%d" % index, Vector3(width * 0.5 - side * 1.45, y, 0.020), Vector3(side * 0.45, side * 0.55, depth * 0.78), darker_wood)
		_add_panel("BrassLabelSlot%d" % index, Vector3(0.0, y + 0.028, depth * 0.5 + 0.004), Vector3(0.135, 0.016, 0.003), brass, false)

	_build_wood_grain(width, depth, height)


func _build_drawers() -> void:
	drawers.clear()
	for index in range(3):
		var drawer = DrawerScript.new()
		drawer.name = "Drawer%d" % (index + 1)
		drawer.drawer_id = "drawer_%d" % (index + 1)
		drawer.closed_position = Vector3(0.0, 0.046 + index * 0.084, 0.025)
		drawer.open_amount = 0.0
		add_child(drawer)
		drawers.append(drawer)


func _build_wood_grain(width: float, depth: float, height: float) -> void:
	for index in range(7):
		var z = -depth * 0.36 + index * depth * 0.12
		_add_panel("TopWoodGrain%d" % index, Vector3(0.0, height + 0.0007, z), Vector3(width * 0.86, 0.001, 0.002), Color(0.18, 0.13, 0.09, 0.55), false)


func _add_panel(panel_name: String, panel_position: Vector3, panel_size: Vector3, color: Color, collision: bool = true) -> void:
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


func _material(color: Color) -> StandardMaterial3D:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.90
	return mat
