extends Node
class_name PhysicsSleepManager

var registered_objects: Array[Node] = []


func register_interactive(object: Node) -> void:
	if not registered_objects.has(object):
		registered_objects.append(object)
	if object.has_method("set_sleeping_state"):
		object.set_sleeping_state(true)


func mark_active(object: Node) -> void:
	if object != null and object.has_method("set_sleeping_state"):
		object.set_sleeping_state(false)


func mark_sleeping(object: Node) -> void:
	if object != null and object.has_method("set_sleeping_state"):
		object.set_sleeping_state(true)


func freeze_all_idle(except_object: Node = null) -> void:
	for object in registered_objects:
		if object != except_object and is_instance_valid(object) and object.has_method("set_sleeping_state"):
			object.set_sleeping_state(true)

