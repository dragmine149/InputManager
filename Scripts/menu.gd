@icon("res://addons/input_manager/icon.png")
class_name InputManagerMenu
extends Control

## The automatically generated UI for manage EVERY single input in the game.

## The colour of the background of the UI.
@export var background_colour: Color = Color.WEB_GRAY:
	set(v):
		background_colour = v;
		color_rect.color = v;
## The theme for the categories. (Will use this nodes theme by default if no specified)
@export var category_theme: Theme;
## The theme for the inputs. (Will use the category theme by default if not specified)
@export var input_theme: Theme;
## To use the inline version instead of the seperate screen version.
@export var in_line: bool = false;

var category_template: PackedScene = preload("res://addons/input_manager/Scenes/input_category_template.tscn");
var input_ui_menu: PackedScene = preload("res://addons/input_manager/Scenes/InputUI.tscn");

@onready var container: HFlowContainer = $Panel/MarginContainer/HFlowContainer;
@onready var input_ui: PanelContainer = $Panel/MarginContainer/CenterContainer/InputUI;
@onready var color_rect: ColorRect = $Panel/ColorRect;


func _init() -> void:
	var panel := PanelContainer.new();
	panel.name = "Panel";
	panel.set_anchors_preset(Control.PRESET_FULL_RECT);
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH;
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH;
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE;
	add_child(panel);

	var color_rect := ColorRect.new();
	color_rect.name = "ColorRect";
	panel.add_child(color_rect);

	var margin_container := MarginContainer.new();
	margin_container.name = "MarginContainer";
	margin_container.grow_horizontal = Control.GROW_DIRECTION_BOTH;
	margin_container.grow_vertical = Control.GROW_DIRECTION_BOTH;
	margin_container.mouse_filter = Control.MOUSE_FILTER_IGNORE;
	panel.add_child(margin_container);

	var h_flow_container := HFlowContainer.new();
	h_flow_container.name = "HFlowContainer";
	h_flow_container.mouse_filter = Control.MOUSE_FILTER_IGNORE;
	h_flow_container.alignment = FlowContainer.ALIGNMENT_CENTER;
	margin_container.add_child(h_flow_container);

	var center_container := CenterContainer.new();
	center_container.name = "CenterContainer";
	center_container.mouse_filter = Control.MOUSE_FILTER_IGNORE;
	margin_container.add_child(center_container);

	var input_ui_elm:PanelContainer = input_ui_menu.instantiate();
	input_ui_elm.name = "InputUI";
	input_ui_elm.hide();
	center_container.add_child(input_ui_elm);


func _ready() -> void:
	load_input_ui();
	color_rect.color = background_colour;
	input_ui.close_ui.connect(input_change_request_finished);


## Executes when the menu loads.
func load_input_ui() -> void:
	var _verbose = ProjectSettings.get_setting("addons/InputManager/verbose", false);
	# Get all the current keybinds.
	if _verbose:
		print_rich("[color=orange]Loading input menu UI[/color]");
	var categories := InputManager.get_input_categories();
	for category in categories:
		if _verbose:
			print_rich("[color=dark-orange]Loading category: %s[/color]" % category);
		var template:Control = category_template.instantiate();
		container.add_child(template);
		template.set_themes(category_theme, input_theme);
		template.set_in_line(in_line);
		template.load_category(category);
		template.connect("input_change_request", input_change_request);

	var template := category_template.instantiate();
	container.add_child(template);
	template.set_in_line(in_line);
	template.set_themes(category_theme, input_theme);
	template.load_category("");
	template.connect("input_change_request", input_change_request);


func input_change_request(input_name: String, input_id: int) -> void:
	container.hide();
	input_ui.show();
	input_ui.load_input(input_name, input_id);


func input_change_request_finished() -> void:
	container.show();
	input_ui.hide();
