class_name ItemManager
extends BuildHandler

@export var item_scene: PackedScene
@export var furniture_handler: BuildHandler

var hover_item: Node2D

func _place_hover_node(tile_global_pos: Vector2) -> void:
	## delete old tile hover node
	if hover_item:
		hover_item.queue_free()
		hover_item = null
	
	var funiture: Furniture = furniture_handler.get_furniture_at_pos(tile_global_pos)
	if not funiture: return
	var hover_node: Node2D = item_scene.instantiate()
	var hover_node_sprite: Sprite2D = hover_node.get_node_or_null("Sprite2D")
	hover_node_sprite.modulate = Color(1, 1, 1, 0.5)
	## update hover node and add hover node to furniture
	hover_item = hover_node
	funiture.node2d.add_child(hover_node)

func _remove_hover_node() -> void:
	if not hover_item: return
	hover_item.queue_free()
	hover_item = null

func _place_item() -> void:
	if not hover_item: return
	var furniture: Furniture = furniture_handler.get_furniture_at_pos(hover_item.global_position)
	if not furniture or furniture.item: return
	var item: Node2D = item_scene.instantiate()
	furniture.item = item
	furniture.node2d.add_child(item)

func _remove_item() -> void:
	if not hover_item: return
	var furniture: Furniture = furniture_handler.get_furniture_at_pos(hover_item.global_position)
	if not furniture or not furniture.item: return
	furniture.item.queue_free()
	furniture.item = null

# override methods
func handle_new_tile_hovered(tile_global_pos: Vector2) -> void:
	_place_hover_node(tile_global_pos)

func handle_tile_mouseout() -> void:
	_remove_hover_node()

func handle_action_pressed() -> void:
	_place_item()

func handle_undo_pressed() -> void:
	_remove_item()
