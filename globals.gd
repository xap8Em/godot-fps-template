extends Node


var _gravity: float


func _init() -> void:
	_gravity = ProjectSettings.get_setting("physics/3d/default_gravity") as float


func get_gravity() -> float:
	return _gravity
