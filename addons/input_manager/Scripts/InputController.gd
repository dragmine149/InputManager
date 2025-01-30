class_name InputController
extends Resource

var inputs: Dictionary = {

}
var _input_count;

func _init() -> void:
	_input_count = ProjectSettings.get_setting("addons/InputManager/input_count", 2);


func _get(property: StringName) -> Variant:
	var empty: Array = [];
	empty.resize(_input_count);
	empty.fill(null);
	return inputs.get(property, empty);


func _set(property: StringName, value: Variant) -> bool:
	if not value is Array[InputEvent]:
		return false;

	inputs[property] = value;
	return true;


func get_names() -> Array:
	return inputs.keys();


func has(key: String) -> bool:
	return inputs.has(key);
