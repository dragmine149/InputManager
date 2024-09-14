class_name InputManagerExportPlugin
extends EditorExportPlugin

func _get_name() -> String:
	return "Input Manager";


func _supports_platform(platform: EditorExportPlatform) -> bool:
	return true


func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
	if ProjectSettings.get_setting("addons/InputManager/export_debug", false):
		return;

	print("Debug: %s" % is_debug);
	if is_debug:
		return;

	var settings := ProjectSettings.get_property_list().map(func(prop):
		return prop.name
	).filter(func(prop):
		return ProjectSettings.has_setting(prop) and prop.begins_with("input/debug-")
	)

	for setting in settings:
		ProjectSettings.set_setting(setting, null);
