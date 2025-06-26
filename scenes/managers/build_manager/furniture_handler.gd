extends PlacementHandler

@export var pickup_scene: PackedScene
@export var inventory_manager: InventoryManager

var furniture_map: Array[Furniture] = []
var hover_node: Node2D

# public methods
func get_furniture_at_pos(global_pos: Vector2) -> Furniture:
	for furniture: Furniture in furniture_map:
		if global_pos in furniture.occupied_tiles:
			return furniture
	return null

# helper functions
func _spawn_furniture_pickup(furniture: Furniture) -> void:
	var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
	var pickup: Pickup = pickup_scene.instantiate()
	pickup.global_position = furniture.global_position
	pickup.start_pos = furniture.global_position
	pickup.end_pos = player.global_position
	furniture.reparent(pickup)
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
	if get_furniture_at_pos(hover_node.global_position): return
	
	# create furniture node
	var furniture: Furniture = item.scene.instantiate()
	furniture.global_position = hover_node.global_position
	furniture.occupied_tiles = [hover_node.global_position]
	# TODO: calculate multi-tiles
	furniture_map.append(furniture)
	# add furniture to scene
	get_tree().root.add_child(furniture)
	return item

func _remove_furniture(furniture: Furniture):
	if not hover_node: return
	furniture_map = furniture_map.filter(func(f): return furniture != f)
	#furniture.queue_free()
	_spawn_furniture_pickup(furniture)

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
	var furniture: Furniture = get_furniture_at_pos(hover_node.global_position)
	_remove_furniture(furniture)

func reset() -> void:
	_remove_hover_node()
