extends PlayerState


func enter(_previous_state_name: String, _data := {}) -> void:
	player.jump_count = 0
	player.jumping = false

func physics_update(delta: float) -> void:
	if player.velocity.x != 0:
		player.decelerate(delta)
	
	if player.get_direction():
		finished.emit(WALK)
	elif Input.is_action_pressed("jump"):
		finished.emit(JUMP)
	elif not player.is_on_floor():
		finished.emit(FALL)
		
	player.move_and_slide()
