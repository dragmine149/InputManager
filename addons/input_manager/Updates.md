# Update Log

## 1.1.0
Some all around improvements as well as some new features

### Added:
- SOME mouse and keyboard images (w/ their own settings in `Project Settings`) (thanks to [kenny.nl](kenny.nl))
- New defaults to default list (`ui_unicode_start`)
- `InputManager.get_icon_path()` which returns all the project path of all the icons needed to show that event.

### Updated:
- **BREAKING** How project settings are handled
- Godot to v4.4 (i do plan on release a v4.0 compatable one at some point though)
- Documentation to use `[param]` instead of `[b]` and `[/b]` tags

### Chore:
- Cleaned up file system to make installation of addon better

### Removed:
- Some exposed variables as they were causing many issues when trying to preview them in the editor

### Fixed:
- UI display not scaling properly
- UI display overflowing the screen in case of too many input categories.
- An error that would occur `InputManager.get_input_text()` if something other than an InputEvent was passed in. (Error on null). It not returns a "(Not Assigned)" instead.
- The export plugin causing an error on the plugin being disabled. (Apparently the export plugin did not need to be freeded...)

## 1.0.0
- Inital Release
