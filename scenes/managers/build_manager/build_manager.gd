extends Node2D

@onready var table_scene: PackedScene = preload("res://scenes/shoppe_furniture/table.tscn")

var temp_hover_node: Node2D
var furniture_map: Array[Furniture] = []

var item_type: String = "furniture"

func _remove_furniture_at_pos(global_pos: Vector2) -> void:
	for furniture: Furniture in furniture_map:
		if furniture.global_pos == global_pos:
			furniture.node2d.queue_free()
	furniture_map = furniture_map.filter(func(f: Furniture): return f.global_pos != global_pos)

func _is_position_occupied(global_pos: Vector2) -> bool:
	for furniture: Furniture in furniture_map:
		if furniture.global_pos == global_pos:
			return true
	return false

func _place_furniture(global_pos: Vector2) -> void:
	var furniture: Furniture = Furniture.new()
	var table: StaticBody2D = table_scene.instantiate()
	table.global_position = global_pos
	furniture.global_pos = global_pos
	furniture.node2d = table
	furniture_map.append(furniture)
	get_tree().root.add_child(table)
	print("furniture_placed")
	
func _create_temp_placeable(global_pos: Vector2) -> void:
	var table: StaticBody2D = table_scene.instantiate()
	var table_sprite: Sprite2D = table.get_node_or_null("Sprite2D")
	table.global_position = global_pos
	table_sprite.modulate = Color(1, 1, 1, 0.5)
	
	temp_hover_node = table
	get_tree().root.add_child(table)

# __SIGNALS__

# user input
func _on_input_manager_action_pressed(event: InputEvent) -> void:
	if item_type == "furniture":
		if not temp_hover_node: return
		if _is_position_occupied(temp_hover_node.global_position): return
		
		_place_furniture(temp_hover_node.global_position)

func _on_input_manager_undo_pressed(event: InputEvent) -> void:
	if temp_hover_node:
		if _is_position_occupied(temp_hover_node.global_position):
			_remove_furniture_at_pos(temp_hover_node.global_position)

# mouse hovering
func _on_tile_manager_new_tile_hovered(tile_global_pos: Vector2) -> void:
	if temp_hover_node:
		temp_hover_node.queue_free()
	_create_temp_placeable(tile_global_pos)

func _on_tile_manager_layer_mouse_out() -> void:
	if temp_hover_node:
		temp_hover_node.queue_free()
		temp_hover_node = null
