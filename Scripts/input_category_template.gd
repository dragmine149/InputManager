extends PanelContainer

signal input_change_request(input_name: String, input_id: int);

var category_theme: Theme;
var input_theme: Theme;
var in_line: bool = false;
var category_template: PackedScene = preload("res://addons/input_manager/Scenes/input_category_template.tscn");
var input_template: PackedScene = preload("res://addons/input_manager/Scenes/input_control.tscn");
@onready var container: VBoxContainer = $MarginContainer/VBoxContainer;
@onready var title: Label = $MarginContainer/VBoxContainer/Title;


func set_themes(cat_theme: Theme, in_theme: Theme) -> void:
	category_theme = cat_theme;
	input_theme = in_theme;
	theme = category_theme;


func set_in_line(state: bool) -> void:
	in_line = state;


func add_inputs(category_to_load: String) -> void:
	var _verbose = ProjectSettings.get_setting("addons/InputManager/verbose", false);
	var inputs := InputManager.get_input_names(category_to_load);
	if _verbose:
		print_rich("[color=green]Input list: %s[/color]" % str(inputs));
	for input in inputs:
		if _verbose:
			print_rich("[color=dark-orange]Loading input: %s[/color]" % input);
		var template := input_template.instantiate();
		container.add_child(template);
		template.theme = input_theme;
		var path:String = "%s/%s" % [category_to_load, input] if category_to_load != "" else input;
		template.load_input(path);
		template.set_in_line(in_line);
		template.connect("input_change_request", input_change_request.emit);


func add_categories(category_to_load: String) -> void:
	if category_to_load == "":
		return;
	container.add_child(HSeparator.new());

	var _verbose = ProjectSettings.get_setting("addons/InputManager/verbose", false);
	var categories := InputManager.get_input_categories(category_to_load);
	if _verbose:
		print_rich("[color=green]Category list: %s[/color]" % str(categories));
	var count:int = 0;
	for category in categories:
		count += 1;
		if _verbose:
			print_rich("[color=dark-orange]Loading category: %s[/color]" % category);
		var template := category_template.instantiate();
		container.add_child(template);
		template.set_themes(category_theme, input_theme);
		template.set_in_line(in_line);
		template.load_category(category_to_load + "/" + category);
		template.connect("input_change_request", input_change_request.emit);
		if count + 1 >= categories.size():
			continue;
		container.add_child(HSeparator.new());


func load_category(category_to_load: String = "") -> void:
	# Get all the current keybinds.
	add_inputs(category_to_load);
	add_categories(category_to_load);

	if category_to_load == "":
		category_to_load = "root";

	name = category_to_load;
	title.text = category_to_load;
