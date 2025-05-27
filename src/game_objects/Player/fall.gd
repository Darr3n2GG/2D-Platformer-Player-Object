extends PlayerState


var is_on_floor_last_frame : bool = false
var can_coyote : bool = false


func physics_update(delta: float) -> void:
	player.fall(delta)	
	player.walk(delta)
	
	if not player.jumping and is_on_floor_last_frame and not can_coyote:
		can_coyote = true
		player.coyote_timer.start()
	
	if player.is_on_floor():
		finished.emit(IDLE)
	elif Input.is_action_just_pressed("jump") and (player.jump_count < player.max_jump_count or can_coyote):
		finished.emit(JUMP)
	
	player.move_and_slide()
	is_on_floor_last_frame = player.is_on_floor()
	
func exit() -> void:
	can_coyote = false


func _on_coyote_timer_timeout() -> void:
	if get_parent().state.name == FALL:
		can_coyote = false
	
	# Recognised as a normal fall instead of a coyote-able fall
	if not player.jumping and not player.is_on_floor():
		player.jump_count += 1
