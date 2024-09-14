class_name InputController
extends Resource

var 	inputs := {

}
var _input_count;

func _init() -> void:
	_input_count = ProjectSettings.get_setting("addons/InputManager/input_count", 2);


func _get(property: StringName) -> Variant:
	var empty: Array[InputEvent] = [];
	empty.resize(_input_count);
	empty.fill(null);
	return inputs.get(property, empty);


func _set(property: StringName, value: Variant) -> bool:
	if value is not Array[InputEvent]:
		return false;

	inputs[property] = value;
	return true;


func _get_property_list() -> Array[Dictionary]:
	var properties:Array[Dictionary] = [];
	for action:String in inputs:
		var hint_string := ",".join(_get(action).map(func(action:InputEvent) -> String:
			if action == null: return "";
			return action.as_text();
		));
		properties.append({
			"name": action.replace('-', '/'),
			"type": TYPE_STRING_NAME,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": hint_string,
		})
	return properties;


func get_names() -> Array:
	return inputs.keys();


func has(key: String) -> bool:
	return inputs.has(key);
