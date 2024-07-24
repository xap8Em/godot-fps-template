extends Control


var _unformatted_info: String
var _info_value_map: Dictionary

@onready var _info_label := $InfoLabel as Label


func _ready() -> void:
	_unformatted_info = _info_label.get_text()


func _process(_delta: float) -> void:
	_info_label.set_text(_unformatted_info.format(_info_value_map))


func set_info_value(info_key: String, info_value) -> void:
	_info_value_map[info_key] = info_value
