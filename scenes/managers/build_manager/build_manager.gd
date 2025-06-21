extends Node2D

@onready var furniture_handler: FurnitureManager = $FurnitureHandler
@onready var item_handler: ItemManager = $ItemHandler

@onready var build_handlers: Dictionary = {
	"furniture" : furniture_handler,
	"item" : item_handler
}
@onready var current_handler: String = "item"

func _get_active_handler() -> BuildHandler:
	return build_handlers.get(current_handler, null)

# user input signals
func _on_input_manager_action_pressed(event: InputEvent) -> void:
	var handler: BuildHandler = _get_active_handler()
	if not handler: return
	handler.handle_action_pressed()

func _on_input_manager_undo_pressed(event: InputEvent) -> void:
	var handler: BuildHandler = _get_active_handler()
	if not handler: return
	handler.handle_undo_pressed()

# hover signals
func _on_tile_manager_new_tile_hovered(tile_global_pos: Vector2) -> void:
	var handler: BuildHandler = _get_active_handler()
	if not handler: return
	handler.handle_new_tile_hovered(tile_global_pos)

func _on_tile_manager_layer_mouse_out() -> void:
	var handler: BuildHandler = _get_active_handler()
	if not handler: return
	handler.handle_tile_mouseout()
