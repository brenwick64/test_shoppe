class_name FurnitureManager
extends BuildHandler

@export var furniture_scene: PackedScene

var furniture_map: Array[Furniture] = []
var furniture_hover_node: Node2D

# __DEBUG__
var DEBUG_PLACEHOLDER_FURNITURE = [
	Vector2i(408, 136),
	Vector2i(424, 136),
	Vector2i(440, 136)
]
func _debug_place_furniture(pos: Vector2) -> void:
	# create furniture object
	var furniture: Furniture = Furniture.new()
	var table: StaticBody2D = furniture_scene.instantiate()
	table.global_position = pos
	furniture.global_pos = pos
	furniture.node2d = table
	furniture_map.append(furniture)
	# add furniture to scene
	get_tree().root.add_child(table)
	
func _ready() -> void:
	for pos: Vector2 in DEBUG_PLACEHOLDER_FURNITURE:
		call_deferred("_debug_place_furniture", pos)
# __DEBUG__

# public methods
func get_furniture_at_pos(global_pos: Vector2) -> Furniture:
	for furniture in furniture_map:
		if furniture.global_pos == global_pos:
			return furniture
	return null

# helper functions
func _place_hover_node(tile_global_pos: Vector2) -> void:
	# delete old tile hover node
	if furniture_hover_node:
		furniture_hover_node.queue_free()
		furniture_hover_node = null

	var hover_node: Node2D = furniture_scene.instantiate()
	var hover_node_sprite: Sprite2D = hover_node.get_node_or_null("Sprite2D")
	hover_node_sprite.modulate = Color(1, 1, 1, 0.5)
	hover_node.global_position = tile_global_pos
	furniture_hover_node = hover_node
	# add hover node to scene
	get_tree().root.add_child(hover_node)

func _remove_hover_node() -> void:
	if not furniture_hover_node: return
	furniture_hover_node.queue_free()
	furniture_hover_node = null

func _place_furniture() -> void:
	# validity checks
	if not furniture_hover_node: return
	if get_furniture_at_pos(furniture_hover_node.global_position): return
	
	var global_pos: Vector2 = furniture_hover_node.global_position
	# create furniture object
	var furniture: Furniture = Furniture.new()
	var table: StaticBody2D = furniture_scene.instantiate()
	table.global_position = global_pos
	furniture.global_pos = global_pos
	furniture.node2d = table
	furniture_map.append(furniture)
	# add furniture to scene
	get_tree().root.add_child(table)

func _remove_furniture() -> void:
	if not furniture_hover_node: return
	var furniture: Furniture = get_furniture_at_pos(furniture_hover_node.global_position)
	if not furniture: return
	furniture.node2d.queue_free()
	furniture_map = furniture_map.filter(func(f): return f.global_pos != furniture.global_pos)

# override methods
func handle_new_tile_hovered(tile_global_pos: Vector2) -> void:
	_place_hover_node(tile_global_pos)

func handle_tile_mouseout() -> void:
	_remove_hover_node()

func handle_action_pressed() -> void:
	_place_furniture()

func handle_undo_pressed() -> void:
	_remove_furniture()
	
func reset() -> void:
	_remove_hover_node()
