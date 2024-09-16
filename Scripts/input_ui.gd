extends PanelContainer

signal close_ui

var can_input: bool = false:
	set(v):
		can_input = v;
		set_process_input(v);
var save_input: String = "";
var save_index: int = 1;
var new_input: InputEvent;

@onready var title: Label = $VBoxContainer/Title;
@onready var input: Label = $VBoxContainer/Input;
@onready var controls: HBoxContainer = $VBoxContainer/HBoxContainer;
@onready var cancel: Button = $VBoxContainer/HBoxContainer/Cancel;
@onready var submit: Button = $VBoxContainer/HBoxContainer/Submit;


func _init() -> void:
	set_process_input(false);


func _input(event: InputEvent) -> void:
	# we are in a zone where we don't want to get the input
	if Rect2(Vector2.ZERO, controls.size).has_point(controls.get_local_mouse_position()):
		return;

	# Release events are annoying to deal with.
	if event.is_released():
		return;

	# Same with mouse motion.
	if event is InputEventMouseMotion:
		return;

	input.text = InputManager.get_input_text(event);
	submit.disabled = false;
	new_input = event;


func _on_cancel_pressed() -> void:
	close_ui.emit();
	can_input = false;


func _on_submit_pressed() -> void:
	InputManager.change_input(save_input, save_index, new_input);
	return _on_cancel_pressed();


func load_input(key: String, index: int) -> void:
	var inputs := InputManager.get_inputs(key);
	var old_input:InputEvent = null;
	if inputs.size() >= index:
		old_input = inputs[index];

	title.text = "Please enter input for: %s" % key;
	input.text = "Old input: %s\n\nWaiting for input..." % (InputManager.get_input_text(old_input) if old_input != null else "None");
	can_input = true;
	submit.disabled = true;

	save_input = key;
	save_index = index;
