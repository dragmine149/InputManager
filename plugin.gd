@tool
extends EditorPlugin

const setting_path := "addons/InputManager/";
var export_plugin: InputManagerExportPlugin;

func _enter_tree() -> void:
	add_autoload_singleton("InputManager", "res://addons/input_manager/Scripts/input_manager.gd");
	export_plugin = InputManagerExportPlugin.new();
	add_export_plugin(export_plugin);

	create_project_settings("export_debug", false, TYPE_BOOL);
	create_project_settings("input_count", 2, TYPE_INT, PROPERTY_HINT_RANGE, "1,2");
	create_project_settings("save_path", "user://inputs.tres", TYPE_STRING);
	create_project_settings("verbose", false, TYPE_BOOL);
	create_project_settings("icons/mouse", false, TYPE_BOOL);


func _exit_tree() -> void:
	remove_autoload_singleton("InputManager");
	remove_export_plugin(export_plugin);
	export_plugin.free();


func _disable_plugin() -> void:
	ProjectSettings.set_setting("addons/InputManager/export_debug", null);
	ProjectSettings.set_setting("addons/InputManager/input_count", null);
	ProjectSettings.set_setting("addons/InputManager/save_path", null);
	ProjectSettings.set_setting("addons/InputManager/verbose", null);
	ProjectSettings.set_setting("addons/InputManager/icons/mouse", null);


func create_project_settings(setting_name: String, setting_default_value: Variant, setting_type: Variant.Type,
			setting_hint: PropertyHint = PROPERTY_HINT_NONE, setting_hint_string: String = "") -> void:
	var setting_full_path = setting_path + setting_name;
	if not ProjectSettings.has_setting(setting_full_path):
		ProjectSettings.set_setting(setting_full_path, setting_default_value);
		ProjectSettings.set_initial_value(setting_full_path, setting_default_value);
	ProjectSettings.add_property_info({
		"name": setting_full_path,
		"type": setting_type,
		"hint": setting_hint,
		"hint_string": setting_hint_string
	});
