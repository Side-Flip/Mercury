extends PlayerStateGravityBase

var hook_target_point = Vector2.ZERO
var arrived_threshold = 20.0

func start():
	var mouse_pos = player.get_global_mouse_position()
	var aim_direction = (mouse_pos - player.global_position).normalized()
	
	player.raycast_hook.target_position = aim_direction * player.hook_max_dist
	player.raycast_hook.force_raycast_update()
	
	if player.raycast_hook.is_colliding():
		hook_target_point = player.raycast_hook.get_collision_point()
	else:
		hook_target_point = player.global_position + (aim_direction * player.hook_max_dist)
		
	player.hook_max_charges -= 1
	
func on_physics_process(delta):
	var direction = (hook_target_point - player.global_position).normalized()
	
	player.velocity = player.velocity.lerp(direction * player.hook_pull_speed, 0.9)
	player.move_and_slide()
			
	var distance = player.global_position.distance_to(hook_target_point)
	if distance < arrived_threshold:
		player.velocity *= 0.5
		state_machine._change_to("PlayerStateFalling")
	
	if player.is_on_wall():
		if player.can_wall_slide:
			state_machine._change_to("PlayerStateWallSliding")
		else: state_machine._change_to("PlayerStateFalling")
		
	elif player.is_on_floor():
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			state_machine._change_to("PlayerStateRunning")
		else: state_machine._change_to("PlayerStateIdle") 
	
func on_input(_event):
	if Input.is_action_just_pressed("jump"):
		player.velocity *= player.hook_boost
		state_machine._change_to("PlayerStateJumping")
