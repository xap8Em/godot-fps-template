class_name Projectile
extends Node3D


const FLIGHT_SPEED: float = 16.0
const MAX_FLIGHT_TIME: float = 2.0

var _flight_velocity: Vector3
var _flight_time: float


func _physics_process(delta: float) -> void:
	_flight_velocity.y -= Globals.get_gravity() * delta

	translate(_flight_velocity * delta)

	_flight_time += delta
	if _flight_time > MAX_FLIGHT_TIME:
		queue_free()


func launch(launch_position: Vector3, launch_direction: Vector3) -> void:
	position = launch_position

	_flight_velocity = launch_direction * FLIGHT_SPEED
