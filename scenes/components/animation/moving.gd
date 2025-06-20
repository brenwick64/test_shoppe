extends Node

func handle_animation(sprite:AnimatedSprite2D, movement_vector:Vector2):
	if Input.is_action_pressed("move_up"):
		sprite.play("walk_up")
		return "up"
	elif Input.is_action_pressed("move_down"):
		sprite.play("walk_down")
		return "down"
	elif Input.is_action_pressed("move_left"):
		sprite.play("walk_left")
		return "left"
	elif Input.is_action_pressed("move_right"):
		sprite.play("walk_right")
		return "right"
