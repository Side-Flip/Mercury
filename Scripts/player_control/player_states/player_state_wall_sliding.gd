extends PlayerStateGravityBase

func start():
	player.reset_double_jump()
	player.reset_hook_charges()

func on_physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")
		
	if direction:
		player.velocity.y += player.wall_slide_gravity * delta
		player.velocity.y = min(player.velocity.y, player.wall_slide_gravity)
		
	handle_gravity(delta)
	player.move_and_slide()
	
	if player.is_on_floor():
		state_machine._change_to("PlayerStateIdle")	

	elif Input.is_action_just_pressed("jump"):
		player.velocity.x = -direction * player.wall_jump_pushback
		state_machine._change_to("PlayerStateJumping")
		
	elif Input.is_action_just_pressed("dash") and player.can_dash:
		state_machine._change_to("PlayerStateDashing")
	
	elif Input.is_action_just_pressed("hook"):
		state_machine._change_to("PlayerStateHooking")
	
	elif not player.is_on_wall():
		state_machine._change_to("PlayerStateFalling")
