extends Node
class_name WorldState

const SAVE_PATH := "user://world_state.json"


func save_world(main: Node) -> bool:
	var data = main.get_world_state_data()
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_warning("Cannot open world-state file for writing: %s" % SAVE_PATH)
		return false
	file.store_string(JSON.stringify(data, "\t"))
	return true


func load_world(main: Node) -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return false
	var text = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(text)
	if error != OK:
		push_warning("Cannot parse saved world state: %s" % json.get_error_message())
		return false
	if typeof(json.data) != TYPE_DICTIONARY:
		return false
	main.apply_world_state_data(json.data)
	return true


func get_save_path() -> String:
	return ProjectSettings.globalize_path(SAVE_PATH)

