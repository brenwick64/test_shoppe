extends PlacementHandler

@export var pickup_scene: PackedScene
@export var inventory_manager: InventoryManager

var furniture_map: Array[FurnitureMapping] = []
var hover_node: Node2D

# public methods
func get_furniture_map_at_pos(global_pos: Vector2) -> FurnitureMapping:
	for mapping: FurnitureMapping in furniture_map:
		if global_pos in mapping.occupied_tiles:
			return mapping
	return null

# helper functions
func _spawn_furniture_pickup(mapping: FurnitureMapping) -> void:
	var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
	var pickup: Pickup = mapping.furniture.pickup_scene.instantiate()
	pickup.global_position = mapping.furniture_node.global_position
	pickup.start_pos = mapping.furniture_node.global_position
	pickup.end_pos = player.global_position
	pickup.item_data = mapping.furniture
	mapping.furniture_node.reparent(pickup)
	get_tree().root.add_child(pickup)

func _place_hover_node(tile_global_pos: Vector2, item: RItem) -> void:
	# delete old hover node
	if hover_node:
		hover_node.queue_free()
		hover_node = null

	var new_hover_node: Node2D = item.scene.instantiate()
	var hover_node_sprite: Sprite2D = new_hover_node.get_node_or_null("Sprite2D")
	hover_node_sprite.modulate = Color(1, 1, 1, 0.5)
	new_hover_node.global_position = tile_global_pos
	
	# add hover node to scene
	get_tree().root.add_child(new_hover_node)
	hover_node = new_hover_node

func _remove_hover_node() -> void:
	if not hover_node: return
	hover_node.queue_free()
	hover_node = null

func _place_furniture(item: RItem) -> RItem:
	# validity checks
	if not hover_node: return
	if get_furniture_map_at_pos(hover_node.global_position): return
	
	# create furniture node
	var new_map: FurnitureMapping = FurnitureMapping.new()
	new_map.furniture = item
	new_map.occupied_tiles = [hover_node.global_position]
	var furniture: Furniture = item.scene.instantiate()
	furniture.global_position = hover_node.global_position
	new_map.furniture_node = furniture
	furniture_map.append(new_map)
	# add furniture to scene
	get_tree().root.add_child(furniture)
	return item

func _remove_furniture(mapping: FurnitureMapping):
	if not hover_node: return
	furniture_map = furniture_map.filter(func(f): return mapping.furniture_node != f.furniture_node)
	mapping.furniture_node.queue_free()
	_spawn_furniture_pickup(mapping)

# override methods
func handle_new_tile_hovered(tile_global_pos: Vector2, item: RItem) -> void:
	_place_hover_node(tile_global_pos, item)

func handle_tile_mouseout() -> void:
	_remove_hover_node()

func handle_action(item: RItem) -> void:
	var placed_furniture: RItem = _place_furniture(item)
	if placed_furniture:
		inventory_manager.remove_item(placed_furniture)

func handle_undo() -> void:
	var mapping: FurnitureMapping = get_furniture_map_at_pos(hover_node.global_position)
	if mapping:
		_remove_furniture(mapping)

func reset() -> void:
	_remove_hover_node()
