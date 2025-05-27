extends PlayerState


func enter(_previous_state_name: String, _data := {}) -> void:
	if player.max_jump_count != 1:
		player.jump_count = player.max_jump_count - 2
	else:
		player.jump_count = 0
	player.animation_player.stop()

func physics_update(_delta: float) -> void:
	if Input.is_action_pressed("climb") and player.is_on_wall():
		player.velocity.y = move_toward(player.velocity.y, 0, 100.0)
		if Input.is_action_just_pressed("jump"):
			finished.emit(JUMP, { "wall_normal_x" : get_rounded_wall_normal_x() })
	else:
		finished.emit(FALL)
	player.move_and_slide()
		

func get_rounded_wall_normal_x() -> float:
	var normal = player.get_wall_normal()
	return roundf(normal.x)
	
