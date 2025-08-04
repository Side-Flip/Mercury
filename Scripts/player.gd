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
@export var can_double_jump = false
@export var can_dash = false
@export var can_wall_slide = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var dash_cooldown: Timer = $DashCooldown


var double_jump_available = true
var dash_available = true

var can_coyote_jump = false
var jump_buffer = false

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

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	
	#Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
