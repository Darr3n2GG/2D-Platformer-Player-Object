class_name KeyTimer extends Node

@export var target_key: StringName
var _time_elapsed: float


func _process(delta: float) -> void:
	if Input.is_action_pressed(target_key):
		_time_elapsed += delta
	
	if Input.is_action_just_released(target_key):
		reset_timer()
		
func reset_timer() -> void:
	_time_elapsed = 0.0
