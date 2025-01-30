extends Label

func _input(event: InputEvent) -> void:
	if event.is_action("test1"):
		text = "Test 1";
	if event.is_action("test2"):
		text = "Test 2";
	if event.is_action("test3"):
		text = "Test 3";
	if event.is_action("test4"):
		text = "Test 4";
	if event.is_action("test5"):
		text = "Test 5";
	if event.is_action("test6"):
		text = "Test 6";
