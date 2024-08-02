extends Node


var _window_mode_is_fullscreen: bool


func _init() -> void:
	_window_mode_is_fullscreen = bool(DisplayServer.window_get_mode())


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_window_mode"):
		_toggle_window_mode()


func _toggle_window_mode() -> void:
	_window_mode_is_fullscreen = not _window_mode_is_fullscreen

	DisplayServer.window_set_mode(3 * int(_window_mode_is_fullscreen))
