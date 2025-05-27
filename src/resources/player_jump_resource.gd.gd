class_name PlayerJumpResource extends JumpResource

@export_group("Jump Height")
@export var player_base: float:
	set(value):
		player_base = value
		base = value
		
@export var player_low: float
@export var player_extra: float

@export_group("Jump Time")
@export var player_to_peak: float:
	set(value):
		player_to_peak = value
		to_peak = value
		
@export var player_to_descent: float:
	set(value):
		player_to_descent = value
		to_descent = value


func _init(
		base_jump_height_: float = 0.0, 
		low_jump_height_: float = 0.0, 
		extra_jump_height_: float = 0.0,
		jump_time_to_peak_: float = 0.0,
		jump_time_to_descent_: float = 0.0
	) -> void:
	player_base = base_jump_height_
	player_low = low_jump_height_
	player_extra = extra_jump_height_
	player_to_peak = jump_time_to_peak_
	player_to_descent = jump_time_to_descent_
	
func calculate_extra_jump_velocity() -> float:
	return calculate_jump_velocity(player_extra)
	
func calculate_extra_jump_gravity() -> float:
	return calculate_jump_gravity(player_extra)

func calculate_low_jump_gravity() -> float:
	return calculate_jump_gravity(base, base / player_low)
