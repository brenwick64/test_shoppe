class_name ItemManager
extends BuildHandler
#
#@export var inventory_manager: InventoryManager
#@export var furniture_handler: BuildHandler
#
#var hover_item: Node2D
#
#func _spawn_item_pickup(item: RItem, source_pos: Vector2) -> void:
	#var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
	#var item_pickup: Pickup = item.pickup_scene.instantiate()
	#item_pickup.global_position = source_pos
	#item_pickup.start_pos = source_pos
	#item_pickup.end_pos = player.global_position
	#get_tree().root.add_child(item_pickup)
#
#func _place_hover_node(tile_global_pos: Vector2, item: RItem) -> void:
	### delete old tile hover node
	#if hover_item:
		#hover_item.queue_free()
		#hover_item = null
	#
	#var mapping: FurnitureMapping = furniture_handler.get_furniture_at_pos(tile_global_pos)
	#if not mapping: return
	#var hover_node: Node2D = item.scene.instantiate()
	#var hover_node_sprite: Sprite2D = hover_node.get_node_or_null("Sprite2D")
	#hover_node_sprite.modulate = Color(1, 1, 1, 0.5)
	### update hover node and add hover node to furniture
	#hover_item = hover_node
	#mapping.furniture_node.add_child(hover_node)
	#
#func _remove_hover_node() -> void:
	#if not hover_item: return
	#hover_item.queue_free()
	#hover_item = null
#
#func _place_item(item: RItem) -> void:
	#if not hover_item: return
	#var mapping: FurnitureMapping = furniture_handler.get_furniture_at_pos(hover_item.global_position)
	#if not mapping or mapping.furniture_node.is_full: return
	#var item_scene: Node2D = item.scene.instantiate()
	#mapping.furniture.placed_item = item
	#mapping.furniture_node.add_item(item_scene)
	## remove item from inventory
	#inventory_manager.remove_item(item)
#
#func _remove_item() -> void:
	#if not hover_item: return
	#var mapping: FurnitureMapping = furniture_handler.get_furniture_at_pos(hover_item.global_position)
	#if not mapping or not mapping.furniture.placed_item: return
	#var item_to_remove: RItem = mapping.furniture.placed_item
	#mapping.furniture.placed_item = null
	#mapping.furniture_node.remove_item()
	#_spawn_item_pickup(item_to_remove, mapping.furniture_node.global_position)
#
## override methods
#func handle_new_tile_hovered(tile_global_pos: Vector2, item: RItem) -> void:
	#_place_hover_node(tile_global_pos, item)
#
#func handle_tile_mouseout() -> void:
	#_remove_hover_node()
#
#func handle_action_pressed(item: RItem) -> void:
	#_place_item(item)
#
#func handle_undo_pressed() -> void:
	#_remove_item()
#
#func reset() -> void:
	#_remove_hover_node()
