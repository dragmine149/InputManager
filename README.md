# InputManager

A simple tool to automatically generate a UI for user inputs.

## Features
- Supports loading from InputMap
- Supports default keybinds across different keyboard layouts (As long as set from InputMap)
- Supports saving / loading to files and/or exporting / importing for custom player data
- Supports changing of keybinds via in-line editing or a different menu
- Supports key combos such as `CTRL + SHIFT + O`
- Debug only controls
- Categories
- Theme support for easy customisability

## Partial Features
- Controller support (as well as any other type of input), will work but might not show up as best as they could.

## Set-up
Download this repo and place the folder in `res://addons/input_manager`. Then enable the plugin using the project settings.
If it's not in that folder, errors will appear.
To use the UI in a scene, add the `InputManagerMenu` node to the scene tree. Where you can customise most of the UI elements.

### Categorisation
Inputs can be categorised. To do this, either:

- Use a `-` in the name upon adding inputs to the InputMap. E.g. `Player-Walk Forward`
- Use `InputManager.add_input("Player/Walk Forward", InputEvent);`

Categorise act just like folders, so categorise can be categorised.

## Settings
Some simple settings that can be found under `ProjectSettings/addons/InputManager`

### export_debug
If enabled, on builds where the status is not marked as "debug" (aka release builds), Any input that is part of the "debug" category will be exported.
If disabled, inputs part of the "debug" category will not show up on release builds and will only work in editor playtest / debug builds.

### save_path
The default path to save inputs to upon using `InputManager.save_inputs()` if no path is specified.
Will also by the default path to load from upon game start and using `InputManager.load_inputs()`

### input_count
How many innputs to show up on the auto generate ui. (This is also used behind the scenes for other elements).
Range between 1 and 2 (for now at least).

### verbose
Sets the state of debugging of loading inputs/events into the manager. Can be useful to make sure everything is being loaded correctly.
Only used for debugging.

## Functions + Signals
All functions can be viewed using the built in godot documentation viewer. Just search for `InputManager`

## InputManagerListener
This is a seperate node that can be used elsewhere. Although a basic node, will (upon being activated) listen for any input and save it.
Useful for in-line settings and if you want to use a different menu layout that the one provided.

## Planned features
(Don't know when they will be added though)

- Controller icons
- Better customisable input count (for built in ui)

## Uninstallation
To uninstall, disable the plugin and then remove the folder. By doing so, settings and the autoload will be removed automatically.

## Credits
- [Folder](https://icons8.com/icon/71cUHRMvCNMk/mac-folder) icon by [Icons8](https://icons8.com)
- [Mouse](https://icons8.com/icon/eRF9ENKlYAVl/mouse) icon by [Icons8](https://icons8.com)
- [F5 Key](https://icons8.com/icon/QA1_AvHyXWnM/f5-key) icon by [Icons8](https://icons8.com)
