class_name FurnitureMapping
extends Node

var furniture: RFurniture
var furniture_node: Node2D
var occupied_tiles: Array[Vector2]
var item_mappings: Array[ItemMapping]

func get_item_map_at_tile_coords(tile_coords: Vector2) -> ItemMapping:
	for i_mapping: ItemMapping in item_mappings:
		if tile_coords in i_mapping.occupied_tiles:
			return i_mapping
	return null
