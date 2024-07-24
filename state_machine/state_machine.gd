class_name StateMachine
extends RefCounted


signal current_state_changed(current_state_name: String)

var _state_map: Dictionary
var _current_state: State


func _init(states: Array[State], initial_state_name: String) -> void:
	for state: State in states:
		state.exiting.connect(_change_current_state_to)

		_state_map[state.get_name()] = state

	_current_state = _state_map.get(initial_state_name)


func unhandled_input(event: InputEvent) -> void:
	_current_state.unhandled_input(event)


func physics_process(delta: float) -> void:
	_current_state.physics_process(delta)


func _change_current_state_to(next_state_name: String) -> void:
	var next_state: State = _state_map.get(next_state_name)

	_current_state.exit()
	_current_state = next_state
	_current_state.enter()

	current_state_changed.emit(_current_state.get_name())
