extends PlayerStateGravityBase

func start():
	player.reset_double_jump()
	player.can_dash = true
	player.velocity.x = 0

func on_physics_process(delta):
	player.animated_sprite.play("idle")
	
	if player.jump_buffer:
		player.jump_buffer = false
		state_machine._change_to("PlayerStateJumping")
		
	handle_gravity(delta)
	
	player.move_and_slide()
	
func on_input(_event):
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine._change_to("PlayerStateRunning")
	elif Input.is_action_just_pressed("jump"):
		state_machine._change_to("PlayerStateJumping")
	elif Input.is_action_pressed("dash") and player.can_dash:
		state_machine._change_to("PlayerStateDashing")
