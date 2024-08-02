class_name PlayerCharacter
extends CharacterBody3D


const MAX_RUNNING_SPEED: float = 4.0
const MAX_SPRINT_SPEED: float = 8.0
const MOVEMENT_ACCELERATION: float = 16.0
const MAX_JUMP_HEIGHT: float = 1.0
const PROJECTILE_SCENE: PackedScene = preload("res://projectiles/projectile.tscn")

var _state_machine: StateMachine
var _input_movement_vector: Vector2
var _max_movement_speed: float
var _max_jump_speed: float = sqrt(2 * Globals.get_gravity() * MAX_JUMP_HEIGHT)

@onready var _head := $Head as Node3D


func _init() -> void:
	var states: Array[State] = [
		preload("res://player_characters/states/in_air/falling.gd").new(self),
		preload("res://player_characters/states/in_air/jumping.gd").new(self),
		preload("res://player_characters/states/on_floor/idle.gd").new(self),
		preload("res://player_characters/states/on_floor/moving/running.gd").new(self),
		preload("res://player_characters/states/on_floor/moving/sprinting.gd").new(self),
	]
	_state_machine = StateMachine.new(states, "idle")

	_state_machine.current_state_changed.connect(_on_state_machine_current_state_changed)


func _unhandled_input(event: InputEvent) -> void:
	_state_machine.unhandled_input(event)


func _physics_process(delta: float) -> void:
	_state_machine.physics_process(delta)


func look(event: InputEvent) -> void:
	if (
		event is InputEventMouseMotion
		and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	):
		var mouse_relative_position: Vector2 = (event as InputEventMouseMotion).get_relative()

		rotate_y(-deg_to_rad(mouse_relative_position.x * Settings.get_mouse_sensitivity().x))
		_head.rotate_x(-deg_to_rad(mouse_relative_position.y * Settings.get_mouse_sensitivity().y))

		var head_rotation_degrees = _head.get_rotation_degrees()
		head_rotation_degrees.x = clamp(head_rotation_degrees.x, -89.9, 89.9)
		_head.set_rotation_degrees(head_rotation_degrees)


func apply_jump_velocity() -> void:
	velocity.y = _max_jump_speed


func apply_falling_velocity(delta: float) -> void:
	velocity.y -= Globals.get_gravity() * delta


func move(delta: float) -> void:
	_input_movement_vector = Input.get_vector("move_left","move_right", "move_forward", "move_back")

	var target_movement_velocity: Vector3
	target_movement_velocity = _head.get_global_basis() * Vector3(_input_movement_vector.x, 0.0, _input_movement_vector.y)
	target_movement_velocity.y = 0.0
	target_movement_velocity = target_movement_velocity.normalized() * _max_movement_speed

	var horizontal_velocity: Vector3 = velocity
	horizontal_velocity.y = 0.0

	horizontal_velocity = horizontal_velocity.move_toward(target_movement_velocity, MOVEMENT_ACCELERATION * delta)

	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z

	move_and_slide()

	DebugMenu.set_info_value("player_character/horizontal_speed", horizontal_velocity.length())


func fire_weapon(event: InputEvent) -> void:
	if event.is_action_pressed("fire_weapon"):
		var projectile: Projectile = PROJECTILE_SCENE.instantiate()

		get_parent().add_child(projectile)

		projectile.launch(_head.get_global_position(), (-_head.get_global_basis().z).normalized())


func get_input_movement_vector() -> Vector2:
	return _input_movement_vector


func set_max_movement_speed(value: float) -> void:
	_max_movement_speed = value


func _on_state_machine_current_state_changed(current_state_name: String) -> void:
	DebugMenu.set_info_value("player_character/state", current_state_name)
