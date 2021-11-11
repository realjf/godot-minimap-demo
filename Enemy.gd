extends KinematicBody2D

var minimap_icon = "mob"


export var acceleration = 300
export var speed = 50
export var friction = 200
export var wander_target_range = 4

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = CHASE

onready var wanderController = $WanderController

func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			
			if wanderController.get_time_left() == 0:
				update_wander()
		WANDER:
			if wanderController.get_time_left() == 0:
				update_wander()
		
			accelerate_towards_point(wanderController.target_position, delta)
			
			if global_position.distance_to(wanderController.target_position) <= wander_target_range:
				update_wander()
				
	
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var dir = global_position.direction_to(point)
	velocity = velocity.move_toward(dir * speed, acceleration * delta)

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))
			

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
