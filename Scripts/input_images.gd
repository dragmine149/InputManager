extends VBoxContainer
class_name InputDisplayUI

@onready var img1: TextureRect = $HBoxContainer/TextureRect;
@onready var img2: TextureRect = $HBoxContainer/TextureRect2;
@onready var img3: TextureRect = $HBoxContainer/TextureRect3;
@onready var img4: TextureRect = $HBoxContainer/TextureRect4;
@onready var img5: TextureRect = $HBoxContainer/TextureRect5;
@onready var img_node: HBoxContainer = $HBoxContainer;
@onready var text_node: Label = $Label;
@onready var texture_nodes: Array[TextureRect] = [img1, img2, img3, img4, img5];

func set_images(images: Array[String]) -> void:
	img_node.show();
	text_node.hide();

	images.resize(5);

	for texture_id in texture_nodes.size():
		if images[texture_id] == "":
			texture_nodes[texture_id].texture = null;
			continue;
		texture_nodes[texture_id].texture = load(images[texture_id]);


func set_text(text: String) -> void:
	img_node.hide();
	text_node.show();

	text_node.text = text;


func set_images_and_text(images: Array[String], text: String) -> void:
	set_images(images);
	set_text(text);

	img_node.show();
