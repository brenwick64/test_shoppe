extends Node

#@export var inventory_manager: InventoryManager
#@export var furniture_handler: FurnitureManager
#@export var item_handler: ItemManager
#
#var current_handler: BuildHandler
#var current_item: RItem
#
#func _get_build_handler(item: RItem) -> BuildHandler:
	#if item is RSellable: return item_handler
	#if item is RFurniture: return furniture_handler
	#return null
#
## user input signals
#func _on_input_manager_action_pressed(_event: InputEvent) -> void:
	#if not current_handler or not current_item: return
	#current_handler.handle_action_pressed(current_item)
#
#func _on_input_manager_undo_pressed(_event: InputEvent) -> void:
	#if not current_handler or not current_item: return
	#current_handler.handle_undo_pressed(current_item)
#
## hover signals
#func _on_tile_manager_new_tile_hovered(tile_global_pos: Vector2) -> void:
	#if not current_handler or not current_item: return
	#current_handler.handle_new_tile_hovered(tile_global_pos, current_item)
#
#func _on_tile_manager_layer_mouse_out() -> void:
	#if not current_handler: return
	#current_handler.handle_tile_mouseout()
#
## inventory signals
#func _on_inventory_item_selected(item: RItem) -> void:
	#if current_handler: 
		#current_handler.reset()
	#current_handler = _get_build_handler(item)
	#current_item = item
#
#func _on_inventory_manager_item_depleted(item: RItem) -> void:
	#if not current_handler: return
	#current_handler.reset()
	#current_item = null
