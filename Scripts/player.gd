extends CharacterBody2D
class_name Player

@export var speed = 500.0
@export_range(0,1) var acceleration = 0.1
@export var jump_force = -500
@export var dash_speed = 1000.0
@export var dash_max_distance = 300.0
@export var dash_curve : Curve
@export var wall_jump_pushback = 600
@export var wall_slide_gravity = 1000

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var dash_cooldown: Timer = $DashCooldown
@onready var wall_ray_left: RayCast2D = $WallRayLeft
@onready var wall_ray_right: RayCast2D = $WallRayRight

#My own function to check walls because is_on_wall() is buggy
func is_touching_wall() -> int:
	if wall_ray_left.is_colliding():
		return -1
	elif wall_ray_right.is_colliding():
		return 1
	return 0

##Unlockables
var double_jump = true
var can_dash = true
var can_wall_slide = true

var can_coyote_jump = false
var jump_buffer = false

func start_dash_cooldown():
	can_dash = false
	dash_cooldown.start()

func use_double_jump():
	double_jump = false

func reset_double_jump():
	double_jump = true

func buffer_jump():
	if not jump_buffer:
		jump_buffer = true
		jump_buffer_timer.start()

func _on_jump_buffer_timer_timeout() -> void:
	jump_buffer = false

func start_coyote_time():
	can_coyote_jump = true
	coyote_timer.start()

func _on_coyote_timer_timeout() -> void:
	can_coyote_jump = false

func _on_dash_cooldown_timeout():
	can_dash = true

func h_movement(direction, delta):
	"""
	##Wall sliding
	if is_on_wall() and not is_on_floor():
		if direction:
			is_wall_sliding = true
	else:
		is_wall_sliding = false
	if is_wall_sliding:
		velocity.y += (wall_slide_gravity*delta)
		velocity.y = min(velocity.y, wall_slide_gravity)
"""
func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	
	#Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
