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


func _build_shell() -> void:
	var shell_color = Color(0.28, 0.24, 0.20, 1.0)
	var width = 0.32
	var depth = 0.39
	var height = 0.275
	var side = 0.014
	_add_panel("BottomPanel", Vector3(0.0, side * 0.5, 0.0), Vector3(width, side, depth), shell_color)
	_add_panel("TopPanel", Vector3(0.0, height - side * 0.5, 0.0), Vector3(width, side, depth), shell_color)
	_add_panel("LeftPanel", Vector3(-width * 0.5 + side * 0.5, height * 0.5, 0.0), Vector3(side, height, depth), shell_color)
	_add_panel("RightPanel", Vector3(width * 0.5 - side * 0.5, height * 0.5, 0.0), Vector3(side, height, depth), shell_color)
	_add_panel("BackPanel", Vector3(0.0, height * 0.5, -depth * 0.5 + side * 0.5), Vector3(width, height, side), shell_color)


func _build_drawers() -> void:
	drawers.clear()
	for index in range(3):
		var drawer = DrawerScript.new()
		drawer.name = "Drawer%d" % (index + 1)
		drawer.drawer_id = "drawer_%d" % (index + 1)
		drawer.closed_position = Vector3(0.0, 0.045 + index * 0.079, 0.018)
		drawer.open_amount = 0.0
		add_child(drawer)
		drawers.append(drawer)


func _add_panel(panel_name: String, panel_position: Vector3, panel_size: Vector3, color: Color) -> void:
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


func _material(color: Color) -> StandardMaterial3D:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.88
	return mat

