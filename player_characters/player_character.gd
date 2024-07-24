class_name PlayerCharacter
extends CharacterBody3D


const MAX_MOVEMENT_SPEED: float = 4.0
const MOVEMENT_ACCELERATION: float = 16.0
const MAX_JUMP_HEIGHT: float = 1.0
const MOUSE_SENSITIVITY := Vector2(0.2, 0.2)

var _state_machine: StateMachine
var _input_movement_vector: Vector2
var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _max_jump_speed: float = sqrt(2 * _gravity * MAX_JUMP_HEIGHT)

@onready var _head := $Head as Node3D


func _init() -> void:
	var states: Array[State] = [
		preload("res://player_characters/states/in_air/falling.gd").new(self),
		preload("res://player_characters/states/in_air/jumping.gd").new(self),
		preload("res://player_characters/states/on_floor/idle.gd").new(self),
		preload("res://player_characters/states/on_floor/moving.gd").new(self),
	]
	_state_machine = StateMachine.new(states, "idle")

	_state_machine.current_state_changed.connect(_on_state_machine_current_state_changed)

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
	_state_machine.unhandled_input(event)


func _physics_process(delta: float) -> void:
	_state_machine.physics_process(delta)

	DebugMenu.set_info_value("player_character/speed", get_real_velocity().length())


func look(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_relative_position: Vector2 = (event as InputEventMouseMotion).get_relative()

		rotate_y(-deg_to_rad(mouse_relative_position.x * MOUSE_SENSITIVITY.x))
		_head.rotate_x(-deg_to_rad(mouse_relative_position.y * MOUSE_SENSITIVITY.y))

		var head_rotation_degrees = _head.get_rotation_degrees()
		head_rotation_degrees.x = clamp(head_rotation_degrees.x, -89.9, 89.9)
		_head.set_rotation_degrees(head_rotation_degrees)


func handle_movement_input() -> void:
	_input_movement_vector = Input.get_vector("move_left","move_right", "move_forward", "move_back")


func apply_jump_velocity() -> void:
	velocity.y = _max_jump_speed


func apply_falling_velocity(delta: float) -> void:
	velocity.y -= _gravity * delta


func move(delta: float) -> void:
	var target_movement_velocity: Vector3
	target_movement_velocity = _head.get_global_basis() * Vector3(_input_movement_vector.x, 0.0, _input_movement_vector.y)
	target_movement_velocity.y = 0.0
	target_movement_velocity = target_movement_velocity.normalized() * MAX_MOVEMENT_SPEED

	var horizontal_velocity: Vector3 = velocity
	horizontal_velocity.y = 0.0

	horizontal_velocity = horizontal_velocity.move_toward(target_movement_velocity, MOVEMENT_ACCELERATION * delta)

	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z

	move_and_slide()


func get_input_movement_vector() -> Vector2:
	return _input_movement_vector


func _on_state_machine_current_state_changed(current_state_name: String) -> void:
	DebugMenu.set_info_value("player_character/state", current_state_name)
