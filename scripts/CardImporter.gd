extends Node
class_name CardImporter

var main: Node
var file_dialog: FileDialog


func setup(p_main: Node, p_file_dialog: FileDialog) -> void:
	main = p_main
	file_dialog = p_file_dialog
	if not file_dialog.file_selected.is_connected(_on_file_selected):
		file_dialog.file_selected.connect(_on_file_selected)


func open_import_dialog() -> void:
	if file_dialog == null:
		return
	file_dialog.popup_centered_ratio(0.72)


func _on_file_selected(path: String) -> void:
	var stored_path = _copy_to_user_imports(path)
	main.create_imported_card(stored_path)


func _copy_to_user_imports(source_path: String) -> String:
	var extension = source_path.get_extension().to_lower()
	if extension.is_empty():
		return source_path
	var absolute_dir = ProjectSettings.globalize_path("user://imported_cards")
	DirAccess.make_dir_recursive_absolute(absolute_dir)
	var target_path = "user://imported_cards/card_%d_%d.%s" % [int(Time.get_unix_time_from_system()), Time.get_ticks_msec(), extension]
	var source = FileAccess.open(source_path, FileAccess.READ)
	if source == null:
		return source_path
	var target = FileAccess.open(target_path, FileAccess.WRITE)
	if target == null:
		return source_path
	target.store_buffer(source.get_buffer(source.get_length()))
	return target_path

