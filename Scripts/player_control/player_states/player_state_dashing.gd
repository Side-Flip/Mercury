extends PlayerStateGravityBase

@onready var dash_particles: GPUParticles2D = $"../../DashParticles"

var dash_start_pos = 0
var dash_direction = 0

func start():
	dash_start_pos = player.position.x
	dash_direction = Input.get_axis("move_left", "move_right")
	player.start_dash_cooldown()

func on_physics_process(_delta):
	var current_distance = abs(player.position.x - dash_start_pos)
	if not current_distance >= player.dash_max_distance:
		player.velocity.x = dash_direction * player.dash_speed * player.dash_curve.sample(current_distance / player.dash_max_distance)
		player.velocity.y = 0
		
		dash_particles.emitting = true
		dash_particles.scale.x = -1 if dash_direction < 0 else 1
		
		#handle_gravity(delta)
		player.move_and_slide()
		
		if player.is_on_wall():
			if player.can_wall_slide:
				state_machine._change_to("PlayerStateWallSliding")
			else: state_machine._change_to("PlayerStateFalling")
		
		elif Input.is_action_just_pressed("jump") and player.can_double_jump:
			state_machine._change_to("PlayerStateJumping")
			
	elif player.is_on_floor():
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			state_machine._change_to("PlayerStateRunning")
		else: state_machine._change_to("PlayerStateIdle")
		
	else: state_machine._change_to("PlayerStateFalling")

func end():
	dash_particles.emitting = false
