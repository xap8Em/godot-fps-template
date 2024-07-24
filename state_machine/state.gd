class_name State
extends RefCounted


signal exiting(next_state_name: String)

var _name: String


func enter() -> void:
	pass


func unhandled_input(_event: InputEvent) -> void:
	pass


func physics_process(_delta: float) -> void:
	pass


func exit() -> void:
	pass


func get_name() -> String:
	return _name
