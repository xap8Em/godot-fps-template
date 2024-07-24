class_name PlayerCharacter
extends CharacterBody3D


const MAX_MOVEMENT_SPEED: float = 4.0
const MOVEMENT_ACCELERATION: float = 16.0

var _state_machine: StateMachine
var _input_movement_vector: Vector2

@onready var _head := $Head as Node3D


func _init() -> void:
	var states: Array[State] = [
		preload("res://player_characters/states/idle.gd").new(self),
		preload("res://player_characters/states/moving.gd").new(self),
	]
	_state_machine = StateMachine.new(states, "idle")

	_state_machine.current_state_changed.connect(_on_state_machine_current_state_changed)

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
	_state_machine.unhandled_input(event)


func _physics_process(delta: float) -> void:
	_state_machine.physics_process(delta)

	DebugMenu.set_info_value("player_character/speed", get_real_velocity().length())


func handle_movement_input() -> void:
	_input_movement_vector = Input.get_vector("move_left","move_right", "move_forward", "move_back")


func move(delta: float) -> void:
	var target_movement_velocity: Vector3
	target_movement_velocity = _head.get_global_basis() * Vector3(_input_movement_vector.x, 0.0, _input_movement_vector.y)
	target_movement_velocity.y = 0.0
	target_movement_velocity = target_movement_velocity.normalized() * MAX_MOVEMENT_SPEED

	set_velocity(get_real_velocity().move_toward(target_movement_velocity, MOVEMENT_ACCELERATION * delta))

	move_and_slide()


func get_input_movement_vector() -> Vector2:
	return _input_movement_vector


func _on_state_machine_current_state_changed(current_state_name: String) -> void:
	DebugMenu.set_info_value("player_character/state", current_state_name)
