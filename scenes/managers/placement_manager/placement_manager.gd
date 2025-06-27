extends Node

@onready var furniture_handler: PlacementHandler = $Furniture
@onready var item_handler: PlacementHandler = $Item
@onready var tool_handler: Node = $Tool

var selected_item: RItem

# -- helper functions --
func _get_current_placement_handler(item: RItem) -> PlacementHandler:
	if item is RFurniture: return furniture_handler
	if item is RSellable: return item_handler
	if item is RTool: return tool_handler
	return null

# -- user input --
func _on_input_manager_action_pressed(event: InputEvent) -> void:
	var handler: PlacementHandler = _get_current_placement_handler(selected_item)
	if not handler: return
	handler.handle_action(selected_item)

func _on_input_manager_undo_pressed(event: InputEvent) -> void:
	var handler: PlacementHandler = _get_current_placement_handler(selected_item)
	if not handler: return
	handler.handle_undo()

# -- tile inputs --
func _on_tile_manager_new_tile_hovered(tile_global_pos: Vector2) -> void:
	var handler: PlacementHandler = _get_current_placement_handler(selected_item)
	if not handler: return
	handler.handle_new_tile_hovered(tile_global_pos, selected_item)

func _on_tile_manager_layer_mouse_out() -> void:
	var handler: PlacementHandler = _get_current_placement_handler(selected_item)
	if not handler: return
	handler.handle_tile_mouseout()

# -- ui inputs --
func _on_inventory_item_selected(item: RItem) -> void:
	var handler: PlacementHandler = _get_current_placement_handler(selected_item)
	if handler: 
		handler.reset()
	selected_item = item

# -- inventory inputs --
func _on_inventory_manager_item_depleted(item: RItem) -> void:
	var handler: PlacementHandler = _get_current_placement_handler(selected_item)
	if handler:
		handler.reset()
	selected_item = null
