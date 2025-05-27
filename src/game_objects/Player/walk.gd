extends PlayerState


func physics_update(delta: float) -> void:
	player.fall(delta)
	player.walk(delta)
	
	var direction := player.get_direction()
	if is_equal_approx(direction, 0.0):
		finished.emit(IDLE)
	elif Input.is_action_pressed("jump"):
		finished.emit(JUMP)
	elif not player.is_on_floor():
		finished.emit(FALL)
		
	player.move_and_slide()
