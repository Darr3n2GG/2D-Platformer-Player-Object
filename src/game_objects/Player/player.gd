class_name Player extends CharacterBody2D

@export var max_speed: float = 300.0
@export var acceleration_res: MotionProfile
@export var deceleration_res: MotionProfile
@export var turn_around_res: MotionProfile
@export var jump_resource: PlayerJumpProfile
@export var max_jump_count: int = 1
@export var coyote_frames: float = 6.0


var base_jump_velocity: float
var extra_jump_velocity: float
var jump_gravity: float
var low_jump_gravity: float
var extra_jump_gravity: float
var fall_gravity: float

var jump_count: int = 0
var jumping: bool = false

var motion_behaviour := MotionBehaviour.new()

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coyote_timer: Timer = $CoyoteTimer


func _ready() -> void:
	set_jump_variables()
	set_coyote_wait_time()
	
func _physics_process(delta: float) -> void:
	motion_behaviour.update_motion(delta, velocity.x)
	
	
func fall(delta: float) -> void:
	if not is_on_floor():
		apply_gravity(delta, fall_gravity)

func walk(delta: float) -> void:
	var direction := get_direction()
	if direction != sign(velocity.x) and velocity.x != 0:
		turn_around(delta)
	elif direction:
		accelerate(direction, delta)
	elif !direction and velocity.x != 0:
		decelerate(delta)
	elif direction == 0:
		motion_behaviour.update_state("stationary")
						
func accelerate(direction_: float, delta: float) -> void:
	motion_behaviour.update_state("acceleration")
	base_accelerate(max_speed * direction_, acceleration_res.time, acceleration_res.curve, delta)
	
func decelerate(delta: float) -> void:
	motion_behaviour.update_state("deceleration")
	base_accelerate(0, deceleration_res.time, deceleration_res.curve, delta)
				
func turn_around(delta: float):
	motion_behaviour.update_state("turn_around")
	base_accelerate(0, turn_around_res.time, turn_around_res.curve, delta)
	
func base_accelerate(to_: float, time_: float, curve_: Curve, delta: float) -> void:
	velocity.x = motion_behaviour.calculate_acceleration(velocity.x, to_, max_speed, time_, curve_, delta)
	
func base_jump() -> void:
	jump(base_jump_velocity)
	
func extra_jump() -> void:
	jump(extra_jump_velocity)
	animation_player.play("flip")
	
func base_wall_jump(direction_: float) -> void:
	wall_jump(base_jump_velocity, direction_)
		
func jump(jump_velocity_: float) -> void:
	velocity.y = jump_velocity_
	jump_count += 1
	jumping = true
	
func wall_jump(jump_velocity_: float, direction_: float) -> void:
	velocity = Vector2(direction_ * -1, 1.0) * jump_velocity_
	jump_count += 1
	jumping = true
	
func apply_gravity(delta_: float, gravity_: float) -> void:
	velocity.y += gravity_ * delta_
				
func get_direction() -> float:
	return Input.get_axis("move_left", "move_right")
	
func set_jump_variables() -> void:
	base_jump_velocity = jump_resource.calculate_base_jump_velocity()
	extra_jump_velocity =  jump_resource.calculate_extra_jump_velocity()
	jump_gravity = jump_resource.calculate_base_jump_gravity()
	low_jump_gravity = jump_resource.calculate_low_jump_gravity()
	extra_jump_gravity =  jump_resource.calculate_extra_jump_gravity()
	fall_gravity = jump_resource.calculate_fall_gravity()
	
func set_coyote_wait_time() -> void:
	coyote_timer.wait_time = coyote_frames / 60.0
	
	
#------------------- UNUSED -------------------#	
func calculate_smaple_offset(delta: float, bake_resolution: int, target_sample_time := 1.0 / 60.0) -> float:
	var step_size = 1.0 / bake_resolution
	return step_size * (delta / target_sample_time)
	
func calculate_curve_delta(curve: Curve, sample_offset: float) -> float:
	var t1 = clamp(abs(velocity.x) / max_speed, 0.0, 1.0)
	var t2 = clamp(t1 + sample_offset, 0.0, 1.0)
	return curve.sample_baked(t2) - curve.sample_baked(t1)
	
func get_curve_factor(x_: float, max_: float, curve_: Curve) -> float:
	var t = clamp(abs(x_) / max_, 0.0, 1.0)
	return curve_.sample_baked(t)
