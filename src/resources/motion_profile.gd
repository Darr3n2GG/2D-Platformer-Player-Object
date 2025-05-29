class_name MotionProfile extends Resource

@export var curve: Curve
@export var time: float
@export var min_y: float:
	set(value):
		if is_instance_valid(curve):
			call_deferred("set_curve_min_point_value", value)
			

func _init(curve_: Curve = Curve.new(), time_: float = 0.0, min_y_: float = 0.0) -> void:
	curve = curve_
	time = time_
	min_y = min_y_
	
func set_curve_min_point_value(value: float) -> void:
	curve.set_point_value(0, value)
