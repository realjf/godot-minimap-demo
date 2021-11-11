extends KinematicBody2D

var velocity = Vector2.ZERO
var myRotation
export var speed = 80
export var acceleration = 500
export var friction = 500
export var roll_speed = 110


func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	move_state(delta)


func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	velocity = move_and_slide(velocity)
