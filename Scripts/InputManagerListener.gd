class_name InputManagerListener
extends Node

## Listens for inputs and sends signals to update the corrosponding UI elements
## Note: Escape is treated as cancel.

## The signal that is called once the input has been finishhed.
signal input_finished

## Enable of disable this node. Can be useful for external changing modes.
@export var enabled: bool = true:
	set(v):
		enabled = v;
		set_process_input(v);
## Will automatically try and connect to the "pressed" signal of the parent node.
@export var auto_connect: bool = true;
## The value to use for the input to save to instead of the parent node name.
@export var override_parent_input: String = "";
## The index to save to instead of the default first option of the input.
@export var override_parent_index: int = 0;

var _can_input: bool = false:
	set(v):
		_can_input = v;
		set_process_input(v and enabled);

var _save_input: String = "";
var _save_index: int = 0;
var _parent_node: Button;
var _parent_used: bool = false;
var _original_text: String = "";


func _init() -> void:
	set_process_input(false);


func _ready() -> void:
	_parent_node = get_parent();
	if _parent_node.has_signal("pressed"):
		_parent_node.pressed.connect(load_input.bind("", -1, true));


func _input(event: InputEvent) -> void:
	if not _can_input:
		# Shouldn't have to include this but just to be safe...
		return;

	# Release events are annoying to deal with.
	if event.is_released():
		return;

	# Same with mouse motion.
	if event is InputEventMouseMotion:
		return;

	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			return stop_input();

	stop_input();
	return InputManager.change_input(_save_input, _save_index, event);


func load_input(key: String = "", index: int = -1, parent_button: bool = false) -> void:
	if not enabled:
		return;
	if key == "":
		key = _parent_node.name if override_parent_input == "" else override_parent_input;
	if index == -1:
		index = override_parent_index;

	key = InputManager.to_map_name(key);
	var inputs = InputManager.get_inputs(key);

	_can_input = true;

	_save_input = key;
	_save_index = index;

	if parent_button:
		_original_text = _parent_node.text;
		_parent_node.text = "Awaiting input...";
		_parent_used = true;


func stop_input() -> void:
	_can_input = false;
	if _parent_used:
		_parent_node.text = _original_text;

	_parent_used = false;
	input_finished.emit();
