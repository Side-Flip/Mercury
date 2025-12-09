extends CharacterBody2D
class_name Player

# ------- Normal inertial shit -------
@export_group("Basic movement Settings")
@export var speed = 500.0
@export_range(0,1) var acceleration = 0.1
@export var jump_force = -500

# ------- Dash shit -------
@export_group("Dash Settings")
@export var dash_speed = 1000.0
@export var dash_max_distance = 300.0
@export var dash_curve: Curve

# ------- Wall jump shit -------
@export_group("Wall jump Settings")
@export var wall_jump_pushback = 600
@export var wall_slide_gravity = 1000

# ------- Hook shit -------
@export_group("Hook Settings")
@export var hook_pull_speed = 900.0
@export var hook_boost = 1.3 #Hook boost multiplier
@export var hook_max_dist = 250.0
@export var hook_max_charges = 1
@onready var raycast_hook: RayCast2D = $RayCastHook

# ------- Available shit -------
@export var can_double_jump = false
@export var can_dash = false
@export var can_wall_slide = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var dash_cooldown: Timer = $DashCooldown

# ------- Internal shit to track movement stuff -------
var double_jump_available = true
var dash_available = true
var can_coyote_jump = false
var jump_buffer = false
var current_hook_charges = 0

func start_dash_cooldown():
	dash_available = false
	dash_cooldown.start()

func use_double_jump():
	double_jump_available = false

func reset_double_jump():
	double_jump_available = true

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
	dash_available = true

func reset_hook_charges():
	current_hook_charges = hook_max_charges

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	
	#Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
