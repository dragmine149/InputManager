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
	create_project_settings("icons/folder", "res://addons/input_manager/Assets/Kenney_input-prompts", TYPE_STRING, PROPERTY_HINT_DIR);
	create_project_settings("icons/user_icons", true, TYPE_BOOL);
	create_project_settings("icons/keyboard/folder", "Keyboard & Mouse/Double", TYPE_STRING);
	create_project_settings("icons/keyboard/mouse", "Keyboard & Mouse/Double", TYPE_STRING);
	add_icon_settings();


func _exit_tree() -> void:
	remove_autoload_singleton("InputManager");
	remove_export_plugin(export_plugin);
	export_plugin.free();


func _disable_plugin() -> void:
	var setting_list := ProjectSettings.get_property_list().map(func(prop):
			return prop.name
			).filter(func(prop):
				return ProjectSettings.has_setting(prop)
				);
	for setting:String in setting_list:
		if not setting.begins_with("addons/InputManager"):
			continue;
		ProjectSettings.set_setting(setting, null);

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


func add_icon_settings() -> void:
	create_project_settings("icons/keyboard/0", "keyboard_0.png", TYPE_STRING);
	create_project_settings("icons/keyboard/1", "keyboard_1.png", TYPE_STRING);
	create_project_settings("icons/keyboard/2", "keyboard_2.png", TYPE_STRING);
	create_project_settings("icons/keyboard/3", "keyboard_3.png", TYPE_STRING);
	create_project_settings("icons/keyboard/4", "keyboard_4.png", TYPE_STRING);
	create_project_settings("icons/keyboard/5", "keyboard_5.png", TYPE_STRING);
	create_project_settings("icons/keyboard/6", "keyboard_6.png", TYPE_STRING);
	create_project_settings("icons/keyboard/7", "keyboard_7.png", TYPE_STRING);
	create_project_settings("icons/keyboard/8", "keyboard_8.png", TYPE_STRING);
	create_project_settings("icons/keyboard/9", "keyboard_9.png", TYPE_STRING);
	create_project_settings("icons/keyboard/a", "keyboard_a.png", TYPE_STRING);
	create_project_settings("icons/keyboard/b", "keyboard_b.png", TYPE_STRING);
	create_project_settings("icons/keyboard/c", "keyboard_c.png", TYPE_STRING);
	create_project_settings("icons/keyboard/d", "keyboard_d.png", TYPE_STRING);
	create_project_settings("icons/keyboard/e", "keyboard_e.png", TYPE_STRING);
	create_project_settings("icons/keyboard/f", "keyboard_f.png", TYPE_STRING);
	create_project_settings("icons/keyboard/g", "keyboard_g.png", TYPE_STRING);
	create_project_settings("icons/keyboard/h", "keyboard_h.png", TYPE_STRING);
	create_project_settings("icons/keyboard/i", "keyboard_i.png", TYPE_STRING);
	create_project_settings("icons/keyboard/j", "keyboard_j.png", TYPE_STRING);
	create_project_settings("icons/keyboard/k", "keyboard_k.png", TYPE_STRING);
	create_project_settings("icons/keyboard/l", "keyboard_l.png", TYPE_STRING);
	create_project_settings("icons/keyboard/m", "keyboard_m.png", TYPE_STRING);
	create_project_settings("icons/keyboard/n", "keyboard_n.png", TYPE_STRING);
	create_project_settings("icons/keyboard/o", "keyboard_o.png", TYPE_STRING);
	create_project_settings("icons/keyboard/p", "keyboard_p.png", TYPE_STRING);
	create_project_settings("icons/keyboard/q", "keyboard_q.png", TYPE_STRING);
	create_project_settings("icons/keyboard/r", "keyboard_r.png", TYPE_STRING);
	create_project_settings("icons/keyboard/s", "keyboard_s.png", TYPE_STRING);
	create_project_settings("icons/keyboard/t", "keyboard_t.png", TYPE_STRING);
	create_project_settings("icons/keyboard/u", "keyboard_u.png", TYPE_STRING);
	create_project_settings("icons/keyboard/v", "keyboard_v.png", TYPE_STRING);
	create_project_settings("icons/keyboard/w", "keyboard_w.png", TYPE_STRING);
	create_project_settings("icons/keyboard/x", "keyboard_x.png", TYPE_STRING);
	create_project_settings("icons/keyboard/y", "keyboard_y.png", TYPE_STRING);
	create_project_settings("icons/keyboard/z", "keyboard_z.png", TYPE_STRING);
	create_project_settings("icons/keyboard/alt", "keyboard_alt.png", TYPE_STRING);
	create_project_settings("icons/keyboard/apostrophe", "keyboard_apostrophe.png", TYPE_STRING);
	create_project_settings("icons/keyboard/arrow_down", "keyboard_arrow_down.png", TYPE_STRING);
	create_project_settings("icons/keyboard/arrow_left", "keyboard_arrow_left.png", TYPE_STRING);
	create_project_settings("icons/keyboard/arrow_right", "keyboard_arrow_right.png", TYPE_STRING);
	create_project_settings("icons/keyboard/arrow_up", "keyboard_arrow_up.png", TYPE_STRING);
	create_project_settings("icons/keyboard/asterisk", "keyboard_asterisk.png", TYPE_STRING);
	create_project_settings("icons/keyboard/backspace", "keyboard_backspace_icon.png", TYPE_STRING);
	create_project_settings("icons/keyboard/bracket_close", "keyboard_bracket_close.png", TYPE_STRING);
	create_project_settings("icons/keyboard/greater_bracket", "keyboard_bracket_greater.png", TYPE_STRING);
	create_project_settings("icons/keyboard/less_bracket", "keyboard_bracket_less.png", TYPE_STRING);
	create_project_settings("icons/keyboard/bracket_open", "keyboard_bracket_open.png", TYPE_STRING);
	create_project_settings("icons/keyboard/capslock", "keyboard_capslock_icon.png", TYPE_STRING);
	create_project_settings("icons/keyboard/caret", "keyboard_caret.png", TYPE_STRING);
	create_project_settings("icons/keyboard/colon", "keyboard_colon.png", TYPE_STRING);
	create_project_settings("icons/keyboard/comma", "keyboard_comma.png", TYPE_STRING);
	create_project_settings("icons/keyboard/command", "keyboard_commamnd.png", TYPE_STRING);
	create_project_settings("icons/keyboard/command", "keyboard_commamnd.png", TYPE_STRING);
	create_project_settings("icons/keyboard/delete", "keyboard_delete.png", TYPE_STRING);
	create_project_settings("icons/keyboard/end", "keyboard_end.png", TYPE_STRING);
	create_project_settings("icons/keyboard/enter", "keyboard_enter.png", TYPE_STRING);
	create_project_settings("icons/keyboard/equal", "keyboard_equal.png", TYPE_STRING);
	create_project_settings("icons/keyboard/escape", "keyboard_escape.png", TYPE_STRING);
	create_project_settings("icons/keyboard/exclamation", "keyboard_exclamation.png", TYPE_STRING);
	create_project_settings("icons/keyboard/F1", "keyboard_f1.png", TYPE_STRING);
	create_project_settings("icons/keyboard/F2", "keyboard_f2.png", TYPE_STRING);
	create_project_settings("icons/keyboard/F3", "keyboard_f3.png", TYPE_STRING);
	create_project_settings("icons/keyboard/F4", "keyboard_f4.png", TYPE_STRING);
	create_project_settings("icons/keyboard/F5", "keyboard_f5.png", TYPE_STRING);
	create_project_settings("icons/keyboard/F6", "keyboard_f6.png", TYPE_STRING);
	create_project_settings("icons/keyboard/F7", "keyboard_f7.png", TYPE_STRING);
	create_project_settings("icons/keyboard/F8", "keyboard_f8.png", TYPE_STRING);
	create_project_settings("icons/keyboard/F9", "keyboard_f9.png", TYPE_STRING);
	create_project_settings("icons/keyboard/F10", "keyboard_f10.png", TYPE_STRING);
	create_project_settings("icons/keyboard/F11", "keyboard_f11.png", TYPE_STRING);
	create_project_settings("icons/keyboard/F12", "keyboard_f12.png", TYPE_STRING);
	create_project_settings("icons/keyboard/Function (Fn)", "keyboard_function.png", TYPE_STRING);
	create_project_settings("icons/keyboard/home", "keyboard_home.png", TYPE_STRING);
	create_project_settings("icons/keyboard/insert", "keyboard_insert.png", TYPE_STRING);
	create_project_settings("icons/keyboard/minus", "keyboard_minus.png", TYPE_STRING);
	create_project_settings("icons/keyboard/numlock", "keyboard_numlock.png", TYPE_STRING);
	create_project_settings("icons/keyboard/numpad_enter", "keyboard_numpad_enter.png", TYPE_STRING);
	create_project_settings("icons/keyboard/numpad_plus", "keyboard_numpad_plus.png", TYPE_STRING);
	create_project_settings("icons/keyboard/option", "keyboard_option.png", TYPE_STRING);
	create_project_settings("icons/keyboard/page_down", "keyboard_page_down.png", TYPE_STRING);
	create_project_settings("icons/keyboard/page_up", "keyboard_page_up.png", TYPE_STRING);
	create_project_settings("icons/keyboard/period", "keyboard_period.png", TYPE_STRING);
	create_project_settings("icons/keyboard/plus", "keyboard_plus.png", TYPE_STRING);
	create_project_settings("icons/keyboard/print_screen", "keyboard_print_screen.png", TYPE_STRING);
	create_project_settings("icons/keyboard/question", "keyboard_question.png", TYPE_STRING);
	create_project_settings("icons/keyboard/quote", "keyboard_quote.png", TYPE_STRING);
	create_project_settings("icons/keyboard/return", "keyboard_return.png", TYPE_STRING);
	create_project_settings("icons/keyboard/semi_colon", "keyboard_semi_colon.png", TYPE_STRING);
	create_project_settings("icons/keyboard/shift", "keyboard_shift.png", TYPE_STRING);
	create_project_settings("icons/keyboard/slash_back", "keyboard_slash_back.png", TYPE_STRING);
	create_project_settings("icons/keyboard/slash_forward", "keyboard_slash_forward.png", TYPE_STRING);
	create_project_settings("icons/keyboard/space", "keyboard_space.png", TYPE_STRING);
	create_project_settings("icons/keyboard/tab", "keyboard_tab_icon.png", TYPE_STRING);
	create_project_settings("icons/keyboard/tilde", "keyboard_tilde.png", TYPE_STRING);
	create_project_settings("icons/keyboard/windows", "keyboard_win.png", TYPE_STRING);

	create_project_settings("icons/mouse/left click ", "mouse_left.png", TYPE_STRING);
	create_project_settings("icons/mouse/right click", "mouse_right.png", TYPE_STRING);
	create_project_settings("icons/mouse/scroll click", "mouse_scroll.png", TYPE_STRING);
