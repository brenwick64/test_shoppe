extends PlacementHandler

@export var inventory_manager: InventoryManager
@export var furniture_handler: PlacementHandler

var hover_node: Node2D

## -- helper functions --
func _remove_hover_node() -> void:
	if not hover_node: return
	hover_node.queue_free()
	hover_node = null

func _get_furniture_slot(tile_global_pos: Vector2) -> Node2D:
	var mapping: FurnitureMapping = furniture_handler.get_furniture_map_at_pos(tile_global_pos)
	if not mapping: return null
	# TODO: change this based on larger furniture
	var open_slot: Node2D = mapping.furniture_node.get_open_slot()
	if not open_slot: return null
	return open_slot

func _place_hover_node(item: RItem, open_slot: Node2D) -> void:
	# delete old tile hover node
	if hover_node:
		hover_node.queue_free()
		hover_node = null
	
	# create new hover node and it to furniture slot
	var new_hover_node: Node2D = item.scene.instantiate()
	var hover_node_sprite: Sprite2D = new_hover_node.get_node_or_null("Sprite2D")
	hover_node_sprite.modulate = Color(1, 1, 1, 0.5)
	hover_node = new_hover_node
	open_slot.add_child(hover_node)

func _place_item(item: RItem) -> void:
	if not hover_node: return
	var target_slot: Node2D = hover_node.get_parent()
	var item_scene: Node2D = item.scene.instantiate()
	_remove_hover_node()
	target_slot.add_child(item_scene)
	# remove item from inventory
	inventory_manager.remove_item(item)

## -- override methods --
func handle_new_tile_hovered(tile_global_pos: Vector2, item: RItem) -> void:
	var free_slot: Node2D = _get_furniture_slot(tile_global_pos)
	if not free_slot: 
		_remove_hover_node()
		return
	_place_hover_node(item, free_slot)

func handle_tile_mouseout() -> void:
	_remove_hover_node()

func handle_action(item: RItem) -> void:
	_place_item(item)

func handle_undo() -> void:
	pass

func reset() -> void:
	_remove_hover_node()
