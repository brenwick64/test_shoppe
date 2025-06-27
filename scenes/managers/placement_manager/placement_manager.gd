extends Node

@onready var furniture_handler: PlacementHandler = $Furniture
@onready var item_handler: PlacementHandler = $Item
@onready var tool_handler: Node = $Tool

var selected_item: RItem
var current_tile_pos: Vector2

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

# -- tile inputs --
func _on_tile_manager_new_tile_hovered(tile_global_pos: Vector2) -> void:
	var handler: PlacementHandler = _get_current_placement_handler(selected_item)
	if not handler: return
	current_tile_pos = tile_global_pos
	handler.handle_new_tile_hovered(current_tile_pos, selected_item)

func _on_tile_manager_layer_mouse_out() -> void:
	var handler: PlacementHandler = _get_current_placement_handler(selected_item)
	if not handler: return
	handler.handle_tile_mouseout()

# -- ui inputs --
func _on_inventory_item_selected(item: RItem) -> void:
	var handler: PlacementHandler = _get_current_placement_handler(selected_item)
	if item == selected_item: return
	if handler: 
		handler.reset()
	selected_item = item
	_on_tile_manager_new_tile_hovered(current_tile_pos)

# -- inventory inputs --
func _on_inventory_manager_item_depleted(item: RItem) -> void:
	var handler: PlacementHandler = _get_current_placement_handler(selected_item)
	if handler:
		handler.reset()
	selected_item = null
	
# -- child events --
func _on_tool_item_removed(_item: RItem) -> void:
	# Hacky way to force update on new tile (improves responsiveness)
	_on_tile_manager_new_tile_hovered(current_tile_pos)
