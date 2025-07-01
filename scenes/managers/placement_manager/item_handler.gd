extends PlacementHandler

@onready var outline_item: Shader = preload("res://shaders/outline_sprite.gdshader")

@export var tile_manager: TileManager
@export var inventory_manager: InventoryManager
@export var furniture_handler: PlacementHandler

var hovered_tile_gp: Vector2
var hover_node: Node2D

## -- public methods --
func remove_item(f_mapping: FurnitureMapping, i_mapping: ItemMapping) -> void:
	f_mapping.item_mappings = f_mapping.item_mappings.filter(func(i): return i_mapping.item_node != i.item_node)
	i_mapping.item_node.queue_free()
	_spawn_item_pickup(i_mapping)

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
	# create item instance and add to open slot
	var item_ins: Node2D = item.scene.instantiate()
	var open_slot: Node2D = hover_node.get_parent()
	open_slot.add_child(item_ins)
	# manually add item shader
	var sprite: Sprite2D = item_ins.get_node("Sprite2D")
	var material: ShaderMaterial = ShaderMaterial.new()
	material.shader = outline_item
	sprite.material = material
	# create item mapping reference and add it to furniture mapping
	var f_mapping: FurnitureMapping = furniture_handler.get_furniture_map_at_pos(hovered_tile_gp)
	var i_mapping: ItemMapping = ItemMapping.new()
	i_mapping.item = item
	i_mapping.item_node = item_ins
	i_mapping.occupied_tiles = [tile_manager.get_tile_coords_from_gp(open_slot.global_position)]
	f_mapping.item_mappings.append(i_mapping)
	
	# remove hover node
	_remove_hover_node()
	# remove item from inventory
	inventory_manager.remove_item(item)

func _spawn_item_pickup(i_mapping: ItemMapping) -> void:
	var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
	var pickup: Pickup = i_mapping.item.pickup_scene.instantiate()
	pickup.global_position = i_mapping.item_node.global_position
	pickup.start_pos = i_mapping.item_node.global_position
	pickup.end_pos = player.global_position
	pickup.item_data = i_mapping.item
	i_mapping.item_node.reparent(pickup)
	get_tree().root.add_child(pickup)

## -- methods overrides --
func handle_new_tile_hovered(tile_global_pos: Vector2, item: RItem) -> void:
	hovered_tile_gp = tile_global_pos
	var free_slot: Node2D = _get_furniture_slot(tile_global_pos)
	if free_slot:
		_place_hover_node(item, free_slot)
	else:
		_remove_hover_node()

func handle_tile_mouseout() -> void:
	_remove_hover_node()

func handle_action(item: RItem) -> void:
	_place_item(item)

func reset() -> void:
	_remove_hover_node()
