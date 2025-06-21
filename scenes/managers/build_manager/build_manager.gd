extends Node2D

@onready var table_scene: PackedScene = preload("res://scenes/shoppe_furniture/table.tscn")
@onready var item_scene: PackedScene = preload("res://scenes/shoppe_furniture/potion.tscn")

@onready var TEST_FURNITURE_POS_ARR: Array[Vector2i] = [
	Vector2i(408, 136),
	Vector2i(424, 136),
	Vector2i(440, 136),
]

var temp_hover_node: Node2D
var furniture_map: Array[Furniture] = []
var item_type: String = "item"

func _ready() -> void:
	for test_coords: Vector2i in TEST_FURNITURE_POS_ARR:
		call_deferred("_place_furniture", test_coords)

func _remove_furniture(furniture: Furniture) -> void:
	furniture.node2d.queue_free()
	furniture_map = furniture_map.filter(func(f: Furniture): return f.global_pos != furniture.global_pos)

func _get_furniture_at_pos(global_pos: Vector2) -> Furniture:
	for furniture: Furniture in furniture_map:
		if furniture.global_pos == global_pos:
			return furniture
	return null

func _place_furniture(global_pos: Vector2) -> void:
	var furniture: Furniture = Furniture.new()
	var table: StaticBody2D = table_scene.instantiate()
	table.global_position = global_pos
	furniture.global_pos = global_pos
	furniture.node2d = table
	furniture_map.append(furniture)
	get_tree().root.add_child(table)
	print("furniture_placed")

func _place_item(furniture: Furniture) -> void:
	var item: Node2D = item_scene.instantiate()
	print("placing item: " + str(item.name))
	furniture.is_full = true
	furniture.node2d.add_child(item)

func _create_temp_placeable(global_pos: Vector2) -> void:
	if item_type == "furniture":
		var table: StaticBody2D = table_scene.instantiate()
		var table_sprite: Sprite2D = table.get_node_or_null("Sprite2D")
		table.global_position = global_pos
		table_sprite.modulate = Color(1, 1, 1, 0.5)
		
		temp_hover_node = table
		get_tree().root.add_child(table)
		
	if item_type == "item":
		var furniture: Furniture = _get_furniture_at_pos(global_pos)
		if not furniture: return
		if furniture.is_full: return
		
		var item: Node2D = item_scene.instantiate()
		var item_sprite: Sprite2D = item.get_node_or_null("Sprite2D")
		item_sprite.modulate = Color(1, 1, 1, 0.5)
		
		temp_hover_node = item
		furniture.node2d.add_child(item)

# __SIGNALS__

# user input
func _on_input_manager_action_pressed(event: InputEvent) -> void:
	if item_type == "furniture":
		if not temp_hover_node: return
		if _get_furniture_at_pos(temp_hover_node.global_position): return
		_place_furniture(temp_hover_node.global_position)
	if item_type == "item":
		if not temp_hover_node: return
		var hovered_furniture: Furniture = _get_furniture_at_pos(temp_hover_node.global_position)
		if not hovered_furniture or hovered_furniture.is_full: return
		_place_item(hovered_furniture)

func _on_input_manager_undo_pressed(event: InputEvent) -> void:
	if not temp_hover_node: return
	var current_furniture: Furniture = _get_furniture_at_pos(temp_hover_node.global_position)
	if not current_furniture: return
	_remove_furniture(current_furniture)

# mouse hovering
func _on_tile_manager_new_tile_hovered(tile_global_pos: Vector2) -> void:
	if temp_hover_node:
		temp_hover_node.queue_free()
		temp_hover_node = null
	_create_temp_placeable(tile_global_pos)

func _on_tile_manager_layer_mouse_out() -> void:
	if temp_hover_node:
		temp_hover_node.queue_free()
		temp_hover_node = null
