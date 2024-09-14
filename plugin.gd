@tool
extends EditorPlugin

var export_plugin: InputManagerExportPlugin;

func _enter_tree() -> void:
	add_autoload_singleton("InputManager", "res://addons/input_manager/Scripts/input_manager.gd");
	export_plugin = InputManagerExportPlugin.new();
	add_export_plugin(export_plugin);

	if not ProjectSettings.has_setting("addons/InputManager/export_debug"):
		ProjectSettings.set_setting("addons/InputManager/export_debug", false);
		ProjectSettings.set_initial_value("addons/InputManager/export_debug", false);
	ProjectSettings.add_property_info({
		"name": "addons/InputManager/export_debug",
		"type": TYPE_BOOL,
	})

	if not ProjectSettings.has_setting("addons/InputManager/input_count"):
		ProjectSettings.set_setting("addons/InputManager/input_count", 2);
		ProjectSettings.set_initial_value("addons/InputManager/input_count", 1);
	ProjectSettings.add_property_info({
		"name": "addons/InputManager/input_count",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "1,2"
	});

	if not ProjectSettings.has_setting("addons/InputManager/save_path"):
		ProjectSettings.set_setting("addons/InputManager/save_path", "user://inputs.tres");
		ProjectSettings.set_initial_value("addons/InputManager/save_path", "user://inputs.tres");
	ProjectSettings.add_property_info({
		"name": "addons/InputManager/save_path",
		"type": TYPE_STRING
	});

	if not ProjectSettings.has_setting("addons/InputManager/verbose"):
		ProjectSettings.set_setting("addons/InputManager/verbose", false);
		ProjectSettings.set_initial_value("addons/InputManager/verbose", false);
	ProjectSettings.add_property_info({
		"name": "addons/InputManager/verbose",
		"type": TYPE_BOOL
	});

func _exit_tree() -> void:
	remove_autoload_singleton("InputManager");
	remove_export_plugin(export_plugin);
	export_plugin.free();


func _disable_plugin() -> void:
	ProjectSettings.set_setting("addons/InputManager/export_debug", null);
	ProjectSettings.set_setting("addons/InputManager/input_count", null);
	ProjectSettings.set_setting("addons/InputManager/save_path", null);
	ProjectSettings.set_setting("addons/InputManager/verbose", null);
