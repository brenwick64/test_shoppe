class_name InventoryManager
extends Node

signal inventory_updated(inv_items: Array[InventoryItem])
signal item_depleted(item: RItem)

@export var inv_items: Array[InventoryItem]

func _ready() -> void:
	# initial items
	inventory_updated.emit(inv_items)

func _update_inv_items() -> void:
	for inv_item: InventoryItem in inv_items:
		if inv_item.count <= 0:
			item_depleted.emit(inv_item.item)
	inv_items = inv_items.filter(func(inv_item: InventoryItem): return inv_item.count > 0)
	inventory_updated.emit(inv_items)

func _add_new_inventory_item(new_item: RItem) -> void:
	var new_inv_item: InventoryItem = InventoryItem.new()
	new_inv_item.item = new_item
	new_inv_item.count = 1
	inv_items.append(new_inv_item)

func _increment_existing_item(new_item: RItem) -> void:
	for inv_item: InventoryItem in inv_items:
		if inv_item.item.item_name == new_item.item_name:
			inv_item.count += 1

# methods
func add_item(new_item: RItem) -> void:
	var is_new_item: bool = inv_items.filter(func(i: InventoryItem): return i.item.item_name == new_item.item_name).size() == 0
	if is_new_item: _add_new_inventory_item(new_item)
	else: _increment_existing_item(new_item)
	_update_inv_items()
			
func remove_item(item: RItem) -> void:
	for inv_item: InventoryItem in inv_items:
		if inv_item.item.item_name == item.item_name:
			inv_item.count -= 1
	_update_inv_items()
