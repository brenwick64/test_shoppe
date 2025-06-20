extends Node

func handle_animation(sprite:AnimatedSprite2D, last_direction: String):
	sprite.play("idle_" + last_direction)
