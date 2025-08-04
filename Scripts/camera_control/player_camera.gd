extends Camera2D

@export var look_offset_max_distance = 20
@export var look_offset_speed = 5

var target_offset: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	var input_offset = Vector2.ZERO #The camera comes back to (0,0) if no input is pressed
	
	if Input.is_action_pressed("look_up"):
		input_offset.y -= 1
	if Input.is_action_pressed("look_down"):
		input_offset.y += 1
	if Input.is_action_pressed("look_left"):
		input_offset.x -= 1
	if Input.is_action_pressed("look_right"):
		input_offset.x += 1
		
	target_offset = input_offset * look_offset_max_distance
	
	offset = offset.lerp(target_offset, delta * look_offset_speed)
