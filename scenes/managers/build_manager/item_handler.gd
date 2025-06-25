class_name ItemManager
extends BuildHandler

@export var test_item: RItem
@export var inventory_manager: InventoryManager
@export var furniture_handler: BuildHandler

var hover_item: Node2D

func _spawn_item_pickup(item: RItem, target_pos: Vector2) -> void:
	var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
	var item_pickup = item.pickup_scene.instantiate()
	item_pickup.global_position = target_pos
	item_pickup.target_pos = player.global_position
	get_tree().root.add_child(item_pickup)

func _place_hover_node(tile_global_pos: Vector2, item: RItem) -> void:
	## delete old tile hover node
	if hover_item:
		hover_item.queue_free()
		hover_item = null
	
	var funiture: Furniture = furniture_handler.get_furniture_at_pos(tile_global_pos)
	if not funiture: return
	var hover_node: Node2D = item.scene.instantiate()
	var hover_node_sprite: Sprite2D = hover_node.get_node_or_null("Sprite2D")
	hover_node_sprite.modulate = Color(1, 1, 1, 0.5)
	## update hover node and add hover node to furniture
	hover_item = hover_node
	funiture.node2d.add_child(hover_node)

func _remove_hover_node() -> void:
	if not hover_item: return
	hover_item.queue_free()
	hover_item = null

func _place_item(item: RItem) -> void:
	if not hover_item: return
	var furniture: Furniture = furniture_handler.get_furniture_at_pos(hover_item.global_position)
	if not furniture or furniture.item: return
	var item_scene: Node2D = item.scene.instantiate()
	furniture.item = item_scene
	furniture.node2d.add_child(item_scene)
	# remove item from inventory
	inventory_manager.remove_item(item)

func _remove_item() -> void:
	if not hover_item: return
	var furniture: Furniture = furniture_handler.get_furniture_at_pos(hover_item.global_position)
	if not furniture or not furniture.item: return
	furniture.item.queue_free()
	furniture.item = null
	_spawn_item_pickup(test_item, hover_item.global_position)

# override methods
func handle_new_tile_hovered(tile_global_pos: Vector2, item: RItem) -> void:
	_place_hover_node(tile_global_pos, item)

func handle_tile_mouseout() -> void:
	_remove_hover_node()

func handle_action_pressed(item: RItem) -> void:
	_place_item(item)

func handle_undo_pressed() -> void:
	_remove_item()

func reset() -> void:
	_remove_hover_node()
