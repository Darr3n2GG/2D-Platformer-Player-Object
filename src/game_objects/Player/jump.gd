extends PlayerState


var jump_released : bool = false


func enter(_previous_state_name: String, _data := {}) -> void:
	if player.jump_count > 0 :
		player.extra_jump()
	else:
		player.base_jump()
	
func physics_update(delta: float) -> void:
	if Input.is_action_just_released("jump") and not jump_released:
		jump_released = true
	
	jump_fall(delta)
	player.walk(delta)
		
	if Input.is_action_just_pressed("jump") and player.jump_count < player.max_jump_count:
		player.extra_jump()
	
	if player.is_on_floor():
		finished.emit(IDLE)
	elif player.velocity.y > 0:
		finished.emit(FALL)
		
	player.move_and_slide()
	
func jump_fall(delta: float) -> void:
	if not player.is_on_floor():
		player.apply_gravity(delta, get_jump_gravity())

## Getting the jump gravity depending on the player's current state.[br]
## states: full jumping, low jumping, extra jumping
func get_jump_gravity() -> float:
	if player.jump_count < 2:
		if not jump_released:
			return player.jump_gravity
		else:
			return player.low_jump_gravity
	else:
		return player.extra_jump_gravity
	
func exit() -> void:
	jump_released = false
