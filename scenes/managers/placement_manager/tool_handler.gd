extends PlacementHandler

signal item_removed(item: RItem)

@export var furniture_handler: PlacementHandler
@export var item_handler: PlacementHandler

var hovered_f_mapping: FurnitureMapping
var hovered_i_mapping: ItemMapping
var hovered_node: Node2D

## -- helper functions --
func _get_hovered_node(mapping: FurnitureMapping) -> Node2D:
	var furniture_node: Node2D = mapping.furniture_node
	var item: Node2D = furniture_node.get_item()
	if item: return item
	else: return furniture_node

func _clear_hovered() -> void:
	if hovered_node:
		hovered_node.unfocus()
	hovered_node = null
	if hovered_f_mapping: hovered_f_mapping = null
	if hovered_i_mapping: hovered_i_mapping = null

func _remove_furniture() -> void:
	furniture_handler.remove_furniture(hovered_f_mapping)
	_clear_hovered()

func _remove_item() -> void:
	item_handler.remove_item(hovered_f_mapping, hovered_i_mapping)
	_clear_hovered()

## -- methods overrides --
func handle_new_tile_hovered(tile_global_pos: Vector2, _item: RItem) -> void:
	_clear_hovered() # clear existing node
	
	# get furniture mapping
	var f_mapping: FurnitureMapping = furniture_handler.get_furniture_map_at_pos(tile_global_pos)
	if not f_mapping: return
	# check item mapping for tile
	var i_mapping: ItemMapping = f_mapping.get_item_map_at_pos(tile_global_pos)
	# assign hovered node
	if i_mapping:
		hovered_f_mapping = f_mapping
		hovered_i_mapping = i_mapping
		hovered_node = i_mapping.item_node
	else: 
		hovered_f_mapping = f_mapping
		hovered_node = f_mapping.furniture_node
	hovered_node.focus()

func handle_tile_mouseout() -> void:
	pass

func handle_action(item: RItem) -> void:
	if not hovered_node: return
	if not hovered_f_mapping and not hovered_i_mapping: return
	if hovered_i_mapping: _remove_item()
	elif hovered_f_mapping: _remove_furniture()
	item_removed.emit(item)

func reset() -> void:
	_clear_hovered()
