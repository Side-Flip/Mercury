extends PlayerStateGravityBase

var dash_start_pos = 0
var dash_direction = 0

func start():
	dash_start_pos = player.position.x
	dash_direction = Input.get_axis("move_left", "move_right")
	player.start_dash_cooldown()

func on_physics_process(delta):
	var current_distance = abs(player.position.x - dash_start_pos)
	if not current_distance >= player.dash_max_distance:
		player.velocity.x = dash_direction * player.dash_speed * player.dash_curve.sample(current_distance / player.dash_max_distance)
		player.velocity.y = 0
		
		if player.is_on_wall():
			state_machine._change_to("PlayerStateWallSliding")
		
		elif Input.is_action_just_pressed("jump"):
			if player.is_on_floor():
				state_machine._change_to("PlayerStateJumping")
			else:
				player.buffer_jump()
				
	elif not player.is_on_floor():
		if player.jump_buffer:
			player.jump_buffer = false
			state_machine._change_to("PlayerStateJumping")
		else: state_machine._change_to("PlayerStateFalling")
		
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine._change_to("PlayerStateRunning")
	else:
		state_machine._change_to("PlayerStateIdle")
	handle_gravity(delta)
	player.move_and_slide()
