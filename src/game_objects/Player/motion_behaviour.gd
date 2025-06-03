class_name MotionBehaviour extends RefCounted

const STATES: Dictionary = {
	'ACCELERATION': 'acceleration',
	'DECELERATION': 'deceleration',
	'TURN_AROUND': 'turn_around',
	'STATIONARY': 'stationary'
}

var motion_state: String = STATES.STATIONARY
var time_elapsed: float = 0.0
var time_step: float = 0.01
var velocity_x_last_frame: float

	
func update_motion(_delta: float, velocity_x: float) -> void:
	if motion_state in [STATES.ACCELERATION, STATES.DECELERATION, STATES.TURN_AROUND]:
		time_elapsed += time_step
		clampf(time_elapsed, 0.0, 1.0)
		if motion_state == STATES.TURN_AROUND:
			velocity_x_last_frame = velocity_x
			
func update_state(new_state_: String) -> void:
	if motion_state != new_state_:
		reset_time_elapsed()
	motion_state = new_state_
	
func reset_time_elapsed() -> void:
	time_elapsed = 0.0
	
func calculate_acceleration(from_: float, to_: float, max_: float, time_: float, curve_: Curve, delta: float) -> float:
	var normal_difference = min(time_elapsed / time_, 1.0)
	var curve_factor = curve_.sample_baked(normal_difference)
	return move_toward(from_, to_, (max_ / time_) * curve_factor * delta)
