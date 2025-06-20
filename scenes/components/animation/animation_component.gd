extends Node

@export var parent_scene:Node2D
@export var sprite:AnimatedSprite2D

@onready var idle: Node = $Idle
@onready var moving: Node = $Moving

var last_direction: String = "down"

func handle_movement_or_idle(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		idle.handle_animation(sprite, last_direction)
	else:
		last_direction = moving.handle_animation(sprite, direction)
