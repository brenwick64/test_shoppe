class_name Furniture
extends Node2D

@onready var occupied_tiles: Array[Vector2]
@onready var item_slots: Node2D = $ItemSlots

#func _update_is_full() -> void:
	#if item_slot.get_child_count() > 0:
		#is_full = true
#
#func add_item(item_node: Node2D):
	#if is_full: return
	#item_slot.add_child(item_node)
#
#func remove_item():
	#var item_slot_children: Array[Node] = item_slot.get_children()
	#if item_slot_children.size() > 0:
		#var item: Node = item_slot_children[0]
		#item.queue_free()
