class_name AccelerationResource extends Resource

@export var curve: Curve
@export var time: float

func _init(curve_: Curve = Curve.new(), time_: float = 0.0) -> void:
	curve = curve_
	time = time_
