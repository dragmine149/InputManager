extends VBoxContainer
class_name InputDisplayUI

@onready var img1: TextureRect = $HBoxContainer/TextureRect;
@onready var img2: TextureRect = $HBoxContainer/TextureRect2;
@onready var img3: TextureRect = $HBoxContainer/TextureRect3;
@onready var img4: TextureRect = $HBoxContainer/TextureRect4;
@onready var img5: TextureRect = $HBoxContainer/TextureRect5;
@onready var img_node: HBoxContainer = $HBoxContainer;
@onready var text_node: Label = $MarginContainer/Label;
@onready var texture_nodes: Array[TextureRect] = [img1, img2, img3, img4, img5];

func check_for_images(images: Array[String]) -> bool:
	return images.filter(func(img: String) -> bool: return not img.is_empty()).is_empty();

func _set_images(images: Array[String]) -> void:
	images.resize(5);

	for texture_id in texture_nodes.size():
		if images[texture_id] == "":
			texture_nodes[texture_id].texture = null;
			texture_nodes[texture_id].hide();
			continue;
		texture_nodes[texture_id].texture = load(images[texture_id]);
		texture_nodes[texture_id].show();


func _set_text(text: String) -> void:
	text_node.text = text;


func set_images_and_text(images: Array[String], text: String) -> void:
	_set_images(images);
	_set_text(text);

	img_node.visible = not check_for_images(images);
	text_node.visible = not text.is_empty();


func set_data_from_event(event: InputEvent) -> void:
	set_images_and_text(InputManager.get_icon_path(event), InputManager.get_input_text(event));
