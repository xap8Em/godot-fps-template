extends Node


var _window_mode_is_fullscreen: bool
var _mouse_mode_is_captured: bool


func _init() -> void:
	_window_mode_is_fullscreen = bool(DisplayServer.window_get_mode())

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_mouse_mode_is_captured = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_window_mode"):
		_toggle_window_mode()

	if event.is_action_pressed("pause"):
		_toggle_mouse_mode()


func _toggle_window_mode() -> void:
	_window_mode_is_fullscreen = not _window_mode_is_fullscreen
	DisplayServer.window_set_mode(3 * int(_window_mode_is_fullscreen))


func _toggle_mouse_mode() -> void:
	_mouse_mode_is_captured = not _mouse_mode_is_captured
	Input.set_mouse_mode(2 * int(_mouse_mode_is_captured))
