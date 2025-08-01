extends PlayerStateGravityBase

func start():
	player.reset_double_jump()
	player.can_dash = true

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
	

func on_input(_event):
	if not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		state_machine._change_to("PlayerStateIdle")
	if Input.is_action_just_pressed("jump"):
		state_machine._change_to("PlayerStateJumping")
	if Input.is_action_pressed("dash") and player.can_dash:
		state_machine._change_to("PlayerStateDashing")
