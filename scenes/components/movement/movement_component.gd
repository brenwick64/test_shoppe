class_name MovementComponent
extends Node

@export var parent:CharacterBody2D
@export var MAX_SPEED:int = 5000

var acceleration:float = 0.0

func handle_movement(movement_vector:Vector2, delta:float, speed_scalar:float):
	var current_speed:float = MAX_SPEED * speed_scalar
	if movement_vector != Vector2.ZERO:
		acceleration = clamp(acceleration + 0.1, 0, 1)
	else:
		acceleration = max(acceleration - 0.05, 0) # Smooth deceleration
	parent.velocity = movement_vector * current_speed * acceleration * delta
	parent.move_and_slide()
