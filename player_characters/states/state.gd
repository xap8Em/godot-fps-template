extends State


var _player_character: PlayerCharacter


func _init(player_character: PlayerCharacter) -> void:
	_player_character = player_character


func unhandled_input(event: InputEvent) -> void:
	_player_character.look(event)
