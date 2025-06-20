extends CharacterBody2D

@onready var player_input_component: PlayerInputComponent = $PlayerInputComponent
@onready var animation_component: Node = $AnimationComponent
@onready var movement_component: MovementComponent = $MovementComponent

const SPEED_SCALAR: float = 1.5

func _physics_process(delta):
	var input_direction:Vector2 = player_input_component.get_movement_vector()
	animation_component.handle_movement_or_idle(input_direction)
	movement_component.handle_movement(input_direction, delta, SPEED_SCALAR)
