extends "res://player_characters/states/state.gd"


func _init(player_character: PlayerCharacter) -> void:
	super(player_character)

	_name = "moving"


func physics_process(delta: float) -> void:
	super(delta)

	_player_character.handle_movement_input()
	_player_character.move(delta)

	if (
		_player_character.get_real_velocity().is_zero_approx()
		and _player_character.get_input_movement_vector().is_zero_approx()
	):
		exiting.emit("idle")
