extends PlayerStateGravityBase

func start():
	player.velocity.y = player.jump_force

func on_physics_process(delta):
	player.animated_sprite.play("jump")
	var direction = Input.get_axis("move_left", "move_right")
	player.velocity.x = move_toward(player.velocity.x, direction * player.speed, player.speed*player.acceleration)	
	
	if Input.is_action_just_released("jump") and not player.velocity.y > 0:
		player.velocity.y = 0
	
	handle_gravity(delta)
	player.move_and_slide()
	
	if player.velocity.y > 0: state_machine._change_to("PlayerStateFalling")

	if player.is_on_wall():
		state_machine._change_to("PlayerStateWallSliding")
	
func on_input(_event):
	if Input.is_action_pressed("dash") and player.can_dash:
		state_machine._change_to("PlayerStateDashing")
