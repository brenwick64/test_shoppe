class_name Furniture
extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var item_slots: Node2D = $ItemSlots
@onready var occupied_tiles: Array[Vector2]

@export var tile_matrix: Array[Vector2]

func get_closest_open_slot(tile_global_pos: Vector2) -> Node2D:
	var closest_slot: Node2D
	var slots: Array[Node] = item_slots.get_children()
	for slot: Node2D in slots:
		if slot.get_child_count() == 0:
			if not closest_slot: 
				closest_slot = slot
			elif slot.global_position.distance_to(tile_global_pos) < closest_slot.global_position.distance_to(tile_global_pos):
				closest_slot = slot
	return closest_slot

func focus() -> void:
	var shader_material: ShaderMaterial = sprite_2d.material
	shader_material.set_shader_parameter("width", 0.55)  
	shader_material.set_shader_parameter("pattern", 1)
	
func unfocus() -> void:
	var shader_material: ShaderMaterial = sprite_2d.material
	shader_material.set_shader_parameter("width", 0)
	shader_material.set_shader_parameter("pattern", 1)
