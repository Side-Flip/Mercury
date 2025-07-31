extends CharacterBody2D

@export var speed = 500.0
@export_range(0,1) var acceleration = 0.1
@export var jump_force = -500
@export var dash_speed = 1000.0
@export var dash_max_distance = 300.0
@export var dash_curve : Curve
@export var dash_cooldown = 1.0
@export var wall_jump_pushback = 600
@export var wall_slide_gravity = 1000

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var coyote_timer: Timer = $CoyoteTimer


var is_dashing = false
var dash_start_position = 0
var dash_timer = 0
var dash_direction = 0
var jump_counter = 0
var max_jumps = 2
var can_coyote_jump = false
var jump_buffer = false
var is_wall_sliding = false

func update_animations():
	if is_on_floor():
		if velocity.x:
			animated_sprite.play("walk")
		else:
			animated_sprite.play("idle")
	else:
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")

func v_movement(direction):
	if is_on_floor():
		jump_counter = 0
	else:
		if jump_counter == 0:
			jump_counter +=1 #Para que al caer de un ledge cuente como que saltaste
	if Input.is_action_just_pressed("jump"): 
		if jump_counter < max_jumps or can_coyote_jump:
			jump()
			can_coyote_jump = false
			
		if is_on_wall():
			jump()
			velocity.x = -direction*wall_jump_pushback
			
		elif not jump_buffer:
			jump_buffer = true
			jump_buffer_timer.start()
			
	if Input.is_action_just_released("jump") and not velocity.y > 0:
		velocity.y = 0

func jump():
	velocity.y = jump_force
	jump_counter += 1

func _on_jump_buffer_timer_timeout() -> void:
	jump_buffer = false

func _on_coyote_timer_timeout() -> void:
	can_coyote_jump = false

func h_movement(direction, delta):	
	#Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, speed*acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
			
	##Dash activation
	if Input.is_action_just_pressed("dash") and direction and not is_dashing:
		is_dashing = true
		dash_start_position = position.x
		dash_timer = dash_cooldown
		dash_direction = direction
		
	if is_dashing:
		var current_distance = abs(position.x - dash_start_position)
		if current_distance >= dash_max_distance or is_on_wall():
			is_dashing = false
			
		else:
			velocity.x = dash_direction * dash_speed * dash_curve.sample(current_distance / dash_max_distance)
			velocity.y = 0
	if dash_timer > 0:
		dash_timer -= delta
		
	##Wall sliding
	if is_on_wall() and not is_on_floor():
		if direction:
			is_wall_sliding = true
	else:
		is_wall_sliding = false
	if is_wall_sliding:
		velocity.y += (wall_slide_gravity*delta)
		velocity.y = min(velocity.y, wall_slide_gravity)

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	update_animations()
	v_movement(direction)
	h_movement(direction, delta)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var was_on_floor = is_on_floor()
	move_and_slide()
	
	#Detectar cuando dejamos de tocar el suelo
	if was_on_floor and !is_on_floor() and velocity.y >= 0:
		can_coyote_jump = true
		coyote_timer.start()
	
	#Detectar cuando tocamos el suelo despues de caer
	if !was_on_floor and is_on_floor():
		if jump_buffer:
			jump_buffer = false
			jump()
