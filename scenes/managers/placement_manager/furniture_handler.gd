extends PlacementHandler

@onready var outline_sprite: Shader = preload("res://shaders/outline_sprite.gdshader")
@export var pickup_scene: PackedScene
@export var inventory_manager: InventoryManager

var furniture_mappings: Array[FurnitureMapping] = []
var hover_node: Node2D

# public methods
func get_furniture_map_at_pos(global_pos: Vector2) -> FurnitureMapping:
	for mapping: FurnitureMapping in furniture_mappings:
		if global_pos in mapping.occupied_tiles:
			return mapping
	return null

func remove_furniture(mapping: FurnitureMapping):
	furniture_mappings = furniture_mappings.filter(func(f): return mapping.furniture_node != f.furniture_node)
	mapping.furniture_node.queue_free()
	_spawn_furniture_pickup(mapping)

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
	
	# create furniture_node
	var furniture: Furniture = item.scene.instantiate()
	furniture.global_position = hover_node.global_position
	# assign outline shader
	var sprite: Sprite2D = furniture.get_node("Sprite2D")
	var shader_material: ShaderMaterial = ShaderMaterial.new()
	shader_material.shader = outline_sprite
	sprite.material = shader_material
	# create furniture mapping node
	var new_map: FurnitureMapping = FurnitureMapping.new()
	new_map.furniture = item
	new_map.occupied_tiles = [hover_node.global_position]
	new_map.furniture_node = furniture
	furniture_mappings.append(new_map)
	# add furniture to scene
	get_tree().root.add_child(furniture)
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

func handle_undo() -> void:
	pass

func reset() -> void:
	_remove_hover_node()
