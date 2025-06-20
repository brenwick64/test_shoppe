class_name PlayerInputComponent
extends Node

func get_movement_vector() -> Vector2:
	# Handles cases of digital and analog player inputs (keyboard = digital, controller = analog)
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement).normalized()
