extends "res://player_characters/states/state.gd"


func _init(player_character: PlayerCharacter) -> void:
	super(player_character)

	_name = "idle"


func unhandled_input(event: InputEvent) -> void:
	super(event)

	_player_character.handle_movement_input()

	if not _player_character.get_input_movement_vector().is_zero_approx():
		exiting.emit("moving")
