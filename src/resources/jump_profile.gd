class_name JumpProfile extends Resource

var base: float
var to_peak: float
var to_descent: float


func _init(
		base_jump_height_: float = 0.0, 
		jump_time_to_peak_: float = 0.0,
		jump_time_to_descent_: float = 0.0
	) -> void:
	base = base_jump_height_
	to_peak = jump_time_to_peak_
	to_descent = jump_time_to_descent_


func calculate_base_jump_velocity() -> float:
	return calculate_jump_velocity(base)
	
func calculate_base_jump_gravity() -> float:
	return calculate_jump_gravity(base)

func calculate_jump_velocity(jump_height : float) -> float:
	return ((2.0 * jump_height) / to_peak) * -1.0

func calculate_jump_gravity(jump_height : float, ratio : float = 1) -> float:
	return ((-2.0 * jump_height) / (to_peak * to_peak)) * -1.0 * ratio
	
func calculate_fall_gravity() -> float:
	return ((-2.0 * base) / (to_descent * to_descent)) * -1.0
