extends MarginContainer

signal input_change_request(input_name: String, input_id: int);

var in_line: bool = false;
var _name: String = "";

@onready var input_name_field: Label = $InputControl/Name;
@onready var input_1: Button = $InputControl/Control/Input1;
@onready var input_1_listener: InputManagerListener = $InputControl/Control/Input1/InputManagerListener;
@onready var input_1_images: InputDisplayUI = $InputControl/Control/Inputs;
@onready var input_2: Button = $InputControl/Control2/Input2;
@onready var input_2_listener: InputManagerListener = $InputControl/Control2/Input2/InputManagerListener;
@onready var input_2_images: InputDisplayUI = $InputControl/Control2/Inputs2;


func _on_input_pressed(input_id: int) -> void:
	input_change_request.emit(_name, input_id);


func _get_input_or_empty(input_list: Array[InputEvent], index: int) -> String:
	if input_list.size() <= index:
		return "(Not assigned)";
	var input_info := input_list[index];
	if input_info == null:
		return "(Not assigned)";
	InputManager.get_icon_path(input_info);
	return InputManager.get_input_text(input_info);


func set_in_line(state: bool) -> void:
	in_line = state;
	input_1_listener.enabled = state;
	input_1_listener.override_parent_input = _name;
	input_2_listener.enabled = state;
	input_2_listener.override_parent_input = _name;
	input_2_listener.override_parent_index = 1;


func update_fields(input_name: String = "") -> void:
	if input_name == "":
		input_name = _name;

	var inputs := InputManager.get_inputs(input_name);

	#input_1.text = _get_input_or_empty(inputs, 0);
	#input_2.text = _get_input_or_empty(inputs, 1);

	input_1_images.set_data_from_event(inputs[0]);
	input_2_images.set_data_from_event(inputs[1]);



func load_input(input_name: String) -> void:
	var _verbose = ProjectSettings.get_setting("addons/InputManager/verbose", false);
	if _verbose:
		print_rich("[color=yellow]Loading input: %s[/color]" % input_name);
	input_2.visible = InputManager.input_count == 2;
	name = input_name;
	_name = name.replace('_', '/');
	input_name_field.text = _name;
	if _name.contains('/'):
		input_name_field.text = _name.rsplit("/", true, 1)[1];
	InputManager.connect("input_%s_changed" % InputManager.to_map_name(input_name).replace(' ', '_'), update_fields);
	update_fields(input_name);


func _on_input_1_pressed(extra_arg_0: int) -> void:
	pass # Replace with function body.


func _on_input_2_pressed(extra_arg_0: int) -> void:
	pass # Replace with function body.
