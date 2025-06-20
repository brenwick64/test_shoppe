extends Node2D

signal action_pressed(event: InputEvent)
signal undo_pressed(event: InputEvent)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Action"):
		action_pressed.emit(event)
	if event.is_action_pressed("Undo"):
		undo_pressed.emit(event)
