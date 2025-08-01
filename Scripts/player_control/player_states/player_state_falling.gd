extends PlayerStateGravityBase

func on_physics_process(delta):
	player.animated_sprite.play("fall")
	var direction = Input.get_axis("move_left", "move_right")
	player.velocity.x = move_toward(player.velocity.x, direction * player.speed, player.speed*player.acceleration)
	handle_gravity(delta)
	player.move_and_slide()
	
	if Input.is_action_just_pressed("jump"): 
		if player.double_jump or player.can_coyote_jump:
			state_machine._change_to("PlayerStateJumping")
			player.use_double_jump()
		else: #El jugador se quedo sin saltos y aun no ha tocado el suelo
			player.buffer_jump()
		
	if player.is_on_floor():
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			state_machine._change_to("PlayerStateRunning")
		else:
			state_machine._change_to("PlayerStateIdle")
			
	if player.is_on_wall():
		state_machine._change_to("PlayerStateWallSliding")


func on_input(_event):
	if Input.is_action_just_pressed("dash") and player.can_dash:
		state_machine._change_to("PlayerStateDashing")
		
