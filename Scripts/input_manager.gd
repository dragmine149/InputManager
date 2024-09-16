@icon("res://addons/input_manager/icon.png")
extends Node

## Backend manager of all the input system as well as saving and loading.
## [br]Note: All of these settings are changable under the ProjectSetting category [code]Input Manager[/code]
## [br]
## [br]
## To categories inputs, seperate the input by usisng [code]/[/code]

## Triggers upon [method load_inputs] being completed.
signal on_inputs_loaded

## Where to save the inputs for use next time.
@export var save_path: String = "user://inputs.tres";
## How many things to show up by default. Could be useful for more than one input device or just want
## different keys on the same input
@export_range(1, 2) var input_count: int = 2;

const _defaults: Array[StringName] = [
	&"ui_accept", &"ui_select", &"ui_cancel", &"ui_focus_next", &"ui_focus_prev", &"ui_left",
	&"ui_right", &"ui_up", &"ui_down", &"ui_page_up", &"ui_page_down", &"ui_home", &"ui_end",
	&"ui_cut", &"ui_copy", &"ui_paste", &"ui_undo", &"ui_redo", &"ui_text_completion_query",
	&"ui_text_completion_accept", &"ui_text_completion_replace", &"ui_text_newline",
	&"ui_text_newline_blank", &"ui_text_newline_above", &"ui_text_indent", &"ui_text_dedent",
	&"ui_text_backspace", &"ui_text_backspace_word", &"ui_text_backspace_all_to_left",
	&"ui_text_delete", &"ui_text_delete_word", &"ui_text_delete_all_to_right", &"ui_text_caret_left",
	&"ui_text_caret_word_left", &"ui_text_caret_right", &"ui_text_caret_word_right",
	&"ui_text_caret_up", &"ui_text_caret_down", &"ui_text_caret_line_start", &"ui_text_caret_line_end",
	&"ui_text_caret_page_up", &"ui_text_caret_page_down", &"ui_text_caret_document_start",
	&"ui_text_caret_document_end", &"ui_text_caret_add_below", &"ui_text_caret_add_above",
	&"ui_text_scroll_up", &"ui_text_scroll_down", &"ui_text_select_all",
	&"ui_text_select_word_under_caret", &"ui_text_add_selection_for_next_occurrence",
	&"ui_text_skip_selection_for_next_occurrence", &"ui_text_clear_carets_and_selection",
	&"ui_text_toggle_insert_mode", &"ui_menu", &"ui_text_submit", &"ui_graph_duplicate",
	&"ui_graph_delete", &"ui_filedialog_up_one_level", &"ui_filedialog_refresh",
	&"ui_filedialog_show_hidden", &"ui_swap_input_direction", &"spatial_editor/freelook_left",
	&"spatial_editor/freelook_right", &"spatial_editor/freelook_forward",
	&"spatial_editor/freelook_backwards", &"spatial_editor/freelook_up",
	&"spatial_editor/freelook_down", &"spatial_editor/freelook_speed_modifier",
	&"spatial_editor/freelook_slow_modifier", &"ui_text_backspace_word.macos",
	&"ui_text_backspace_all_to_left.macos", &"ui_text_delete_word.macos",
	&"ui_text_delete_all_to_right.macos", &"ui_text_caret_word_left.macos",
	&"ui_text_caret_word_right.macos", &"ui_text_caret_line_start.macos",
	&"ui_text_caret_line_end.macos", &"ui_text_caret_document_start.macos",
	&"ui_text_caret_document_end.macos", &"ui_text_caret_add_below.macos",
	&"ui_text_caret_add_above.macos", &"ui_text_scroll_up.macos", &"ui_text_scroll_down.macos",
	&"ui_text_select_word_under_caret.macos"
];
var _inputs := InputController.new();
var _call_change := true;
var _verbose: bool;

func _init() -> void:
	save_path = ProjectSettings.get_setting("addons/InputManager/save_path", "user://inputs.tres");
	input_count = ProjectSettings.get_setting("addons/InputManager/input_count", 2);
	_verbose = ProjectSettings.get_setting("addons/InputManager/verbose", false);
	# preload all of the input map actions into the manager already for easy load.
	var actions: Array[StringName] = InputMap.get_actions();
	for action in actions:
		if action in _defaults:
			continue;

		action = to_input_name(action);

		if _verbose:
			print_rich("[color=cyan]Adding input action: %s[/color]" % action);
		var events := InputMap.action_get_events(action);
		if events.size() > 0:
			_call_change = false;
			for action_event in events:
				add_input(action, action_event);
			_call_change = true;
			continue;

		if _verbose:
			print_rich("[color=dark-cyan]Adding input with no events[/color]");
		add_input(action);

#region InputManager

func _add_user_signal(input_name: String) -> void:
	input_name = input_name.replace(' ', '_');
	if not has_signal("input_%s_changed" % input_name):
		add_user_signal("input_%s_changed" % input_name);


## Backend for [method add_input]
func _add_input_no_event(input_name: String) -> Array[InputEvent]:
	input_name = to_map_name(input_name);
	if _inputs.has(input_name):
		return _inputs.get(input_name);

	var empty: Array[InputEvent] = [null, null];
	_inputs.set(input_name, empty);

	# Only add if it doesn't already exist.
	if not InputMap.has_action(input_name):
		InputMap.add_action(input_name);

	_add_user_signal(input_name);
	return empty;


## Add another input under a specified name
## [br]
## [br][b]input_name -[/b] The name of the input to add a new input to
## [br][b]input_event -[/b] The event to add to the input. Leaving blank will just add the actio with no event.
func add_input(input_name: String, input_event: InputEvent = null) -> void:
	input_name = to_map_name(input_name);
	var input = _add_input_no_event(input_name);
	if input_event != null:
		var next_pos = input.find(null);
		# don't like this...
		if next_pos == -1:
			input.append(input_event);
		else:
			input[next_pos] = input_event;

		if not InputMap.action_has_event(input_name, input_event):
			InputMap.action_add_event(input_name, input_event);

	_inputs.set(input_name, input);

	if _call_change and input_event != null:
		emit_signal("input_%s_changed" % input_name.replace(' ', '_'));


## Change an input from one type to another
## [br]
## [br][b]input_name -[/b] The name of the input to change
## [br][b]index -[/b] The position of the old one to remove.
## [br][b]new_input -[/b] The new input value
func change_input(input_name: String, index: int, new_input: InputEvent) -> void:
	input_name = to_map_name(input_name);
	var input_list: Array[InputEvent] = _inputs.get(input_name);
	input_list[index] = new_input;
	_inputs.set(input_name, input_list);
	if _call_change:
		emit_signal("input_%s_changed" % input_name.replace(' ', '_'));


## Returns a list of all the inputs for that given input
## [br]
## [br][b]input_name -[/b] The name of the input to get the inputs for
func get_inputs(input_name: String) -> Array[InputEvent]:
	input_name = to_map_name(input_name);
	return _inputs.get(input_name);


## Returns a list of all the inputs for that given input. But as a single string instead
## [br] Example result: [code]"Ctrl-M, Ctrl-L, A, M"[/code]
## [br]
## [br][b]input_name -[/b] The name of the input to get the inputs for
func get_inputs_as_list(input_name: String) -> String:
	input_name = to_map_name(input_name);
	var input_list: Array[InputEvent] = _inputs.get(input_name);
	return ", ".join(input_list.map(func(input:InputEvent) -> String:
		return input.get_action()
	));


## Returns a list of all the input names.
## [br]
## [br][b]input_category -[/b] The category to get the inputs for. If empty, all top level categories
## are returned.
func get_input_names(input_category: String = "") -> Array:
	var input_list: Array = _inputs.get_names().map(func(input_name: String) -> String:
		input_name = to_input_name(input_name);
		var input_and_category = input_name.rsplit('/', true, 1);
		if input_category == "" and input_and_category.size() == 1:
			return input_and_category[0];

		if input_and_category[0] == input_category:
			return input_and_category[1];

		return "";
	);
	var name_list := input_list.filter(func(input_name: String) -> bool:
		return input_name != "";
	);

	var unique: Dictionary = {};
	for input_name in name_list:
		unique[input_name] = 1;

	return unique.keys();


## Returns a list of all the sub categories under a specific category.
## [br] Will only return that section of categories and no sub-categories.
## [br]
## [br][b]input_category -[/b] The category to get the inputs for. If empty, all top level categories
## are returned.
func get_input_categories(input_category: String = "") -> Array:
	if not input_category.ends_with('/') and input_category != "":
		input_category += '/';

	var input_name_list := _inputs.get_names().map(func(input_name: String) -> String:
		return to_input_name(input_name);
	);
	var no_input_name_list := input_name_list.map(func(input_name: String) -> String:
		var category_path := input_name.get_base_dir();
		if category_path.begins_with(input_category):
			var sub_category := category_path.lstrip(input_category);
			return sub_category.substr(0, sub_category.find('/'));
		return "";
	);
	var name_list := no_input_name_list.filter(func(input_name: String) -> bool:
		return input_name != "";
	);

	var unique: Dictionary = {};
	for input_name in name_list:
		unique[input_name] = 1;

	return unique.keys();


## Removes a specific input from the list.
## [br]
## [br][b]input_name -[/b] The name of the input to remove the item from
## [br][b]index -[/b] The position of the old one to remove.
func remove_input(input_name: String, index: int) -> void:
	input_name = to_map_name(input_name);
	var input_list: Array[InputEvent] = _inputs.get(input_name);
	if index + 1 < input_list.size():
		input_list.remove_at(index);

	_inputs.set(input_name, input_list if not input_list.is_empty() else null);
	if _call_change:
		emit_signal("input_%s_changed" % input_name.replace(' ', '_'));


## Erases all existance of that input. Unlike [remove_input] which only does the index/action
## [br]
## [br][b]input_name -[/b] The name of the input to erase.
## [br][b]remove_signal -[/b] To also remove the signal upon removing the input.
func erase_input(input_name: String, remove_signal: bool = true) -> void:
	input_name = to_map_name(input_name);
	_inputs.set(input_name, null);
	if InputMap.has_action(input_name):
		InputMap.erase_action(input_name);
	if remove_signal:
		remove_user_signal("input_%s_changed" % input_name.replace(' ', '_'));

## Returns the input name as it would be as a map name. Useful in situations like [method Input.is_action_pressed]
## whilst keeping the categorisation ability
## [br]
## [br][b]input_name -[/b] The input name to translate.
func to_map_name(input_name: String) -> String:
	return input_name.replace('/', '-');


## Does the same as [method input_name_to_map_name] but in the other direction
## [br]
## [br][b]input_name -[/b] The input name to translate.
func to_input_name(map_name: String) -> String:
	return map_name.replace('-', '/');


#endregion

#region SaveManager

## Save the inputs to the file.
func save_inputs() -> void:
	var error := ResourceSaver.save(_inputs, save_path);

	# TODO: Error handling.
	if error != OK:
		pass;


## Load inputs from a given file or from the default path if no file is given.
## [br]
## [br][b]file_path -[/b] The path to load from. If not provided, will use the default path as set in
## ProjectSettings/addons/InputManager
func load_inputs(file_path: String = "") -> void:
	if file_path == "" or file_path == null:
		file_path = save_path;

	_inputs = ResourceLoader.load(file_path, "InputController");
	on_inputs_loaded.emit();


## Export the inputs to use / save in a different file
func export_inputs() -> InputController:
	return _inputs;


## Import inputs from a different place.
## [br]
## [br][b]inputs -[/b] The inputs to load.
func import_inputs(inputs: InputController) -> void:
	for action in _inputs.get_names().duplicate():
		erase_input(action, false);

	_inputs = InputController.new();
	for action in inputs.get_names():
		add_input(action, inputs.get(action));

#endregion

#region Display

## Get a text display localised to the users keyboard layout + modifiers.
## [br]If the input is not a key, will return the input text instead.
## [br]
## [br][b]input -[/b] The input to get the text for.
func get_input_text(input:InputEvent) -> String:
	if not input is InputEventKey:
		return input.as_text();

	var physical_key_modifier = input.get_physical_keycode_with_modifiers();
	var keycode = DisplayServer.keyboard_get_keycode_from_physical(physical_key_modifier);
	return OS.get_keycode_string(keycode);

#endregion
