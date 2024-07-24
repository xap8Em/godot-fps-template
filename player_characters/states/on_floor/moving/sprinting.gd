extends "res://player_characters/states/on_floor/moving/moving.gd"


func _init(player_character: PlayerCharacter) -> void:
	super(player_character)

	_name = "sprinting"


func enter() -> void:
	super()

	_player_character.set_max_movement_speed(_player_character.MAX_SPRINT_SPEED)


func unhandled_input(event: InputEvent) -> void:
	super(event)

	if event.is_action_released("sprint"):
		exiting.emit("running")

		return
