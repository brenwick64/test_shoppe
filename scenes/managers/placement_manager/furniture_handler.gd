extends PlacementHandler

@export var pickup_scene: PackedScene
@export var inventory_manager: InventoryManager
@export var tile_manager: TileManager

var furniture_mappings: Array[FurnitureMapping] = []
var hover_node: Node2D

# public methods
func get_furniture_map_at_pos(global_pos: Vector2) -> FurnitureMapping:
	var tile_coords: Vector2 = tile_manager.get_tile_coords_from_gp(global_pos)
	for mapping: FurnitureMapping in furniture_mappings:
		if tile_coords in mapping.occupied_tiles:
			return mapping
	return null

func remove_furniture(mapping: FurnitureMapping):
	furniture_mappings = furniture_mappings.filter(func(f): return mapping.furniture_node != f.furniture_node)
	mapping.furniture_node.queue_free()
	_spawn_furniture_pickup(mapping)

# helper functions
func _is_occupied_tiles(tile_global_pos: Vector2, hover_node: Node2D) -> bool:
	var adjusted_matrix: Array[Vector2] = []
	# build adjusted tile matrix
	for vector: Vector2 in hover_node.tile_matrix:
		var tile_coords = tile_manager.get_tile_coords_from_gp(tile_global_pos) + vector
		adjusted_matrix.append(tile_coords)
	# compare against mapped coords
	for coords: Vector2 in adjusted_matrix:
		for mapping: FurnitureMapping in furniture_mappings:
			if coords in mapping.occupied_tiles:
				return true
	return false

func _is_placable_distance(global_pos: Vector2):
	var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
	var distance: float = global_pos.distance_to(player.global_position)
	return Constants.BUILD_DISTANCE > distance

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
	# validity checks
	#if get_furniture_map_at_pos(tile_global_pos): return
	if not _is_placable_distance(tile_global_pos): return
	var new_hover_node: Node2D = item.placement_preview_scene.instantiate()
	if _is_occupied_tiles(tile_global_pos, new_hover_node): return
	var pivot: Marker2D = new_hover_node.get_node("Pivot")
	new_hover_node.tile_global_pos = tile_global_pos
	new_hover_node.global_position = tile_global_pos - pivot.global_position
	# add hover node to scene
	get_tree().root.call_deferred("add_child", new_hover_node)
	hover_node = new_hover_node

func _remove_hover_node() -> void:
	if not hover_node: return
	hover_node.queue_free()
	hover_node = null

func _place_furniture(item: RItem) -> RItem:
	# validity checks
	if not hover_node: return
	if not hover_node.is_valid_placement: return
	if get_furniture_map_at_pos(hover_node.tile_global_pos): return
	# get shoppe furniture node
	var shoppe_furniture: Node2D = get_tree().get_first_node_in_group("ShoppeFurniture")
	if not shoppe_furniture: return
	# create furniture node
	var furniture: Node2D = item.scene.instantiate()
	furniture.global_position = shoppe_furniture.to_local(hover_node.global_position)
	# create furniture mapping node1wa
	var new_map: FurnitureMapping = FurnitureMapping.new()
	new_map.furniture = item
	new_map.furniture_node = furniture
	# fill in tile_coords
	for vector: Vector2 in hover_node.tile_matrix:
		var tile_coords: Vector2 = tile_manager.get_tile_coords_from_gp(hover_node.tile_global_pos)
		new_map.occupied_tiles.append(vector + tile_coords)

	furniture_mappings.append(new_map)
	# add furniture to scene
	shoppe_furniture.add_child(furniture)
	return item

# override methods
func handle_new_tile_hovered(tile_global_pos: Vector2, item: RItem) -> void:
	_place_hover_node(tile_global_pos, item)

func handle_tile_mouseout() -> void:
	_remove_hover_node()

func handle_action(item: RItem) -> void:
	var placed_furniture: RItem = _place_furniture(item)
	if placed_furniture:
		inventory_manager.remove_item(placed_furniture)

func reset() -> void:
	_remove_hover_node()
