extends PlayerStateGravityBase

func start():
	if player.can_double_jump:
		player.reset_double_jump()

func on_physics_process(delta):
	player.animated_sprite.play("walk")
	var direction = Input.get_axis("move_left", "move_right")
	player.velocity.x = move_toward(player.velocity.x, direction * player.speed, player.speed*player.acceleration)
	
	if not player.is_on_floor():
		player.start_coyote_time()
		state_machine._change_to("PlayerStateFalling")
	
	if player.jump_buffer:
		player.jump_buffer = false
		state_machine._change_to("PlayerStateJumping")
	
	handle_gravity(delta)	
	player.move_and_slide()
	
	if not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		state_machine._change_to("PlayerStateIdle")

func on_input(_event):
	if Input.is_action_just_pressed("jump"):
		state_machine._change_to("PlayerStateJumping")
	elif Input.is_action_just_pressed("dash") and player.can_dash:
		state_machine._change_to("PlayerStateDashing")
	elif Input.is_action_just_pressed("hook"):
		state_machine._change_to("PlayerStateHooking")
