extends Panel

signal item_selected(item: RItem)

@export var item_container_list: HBoxContainer

# overrides
func _ready() -> void:
	for item_container: Node in item_container_list.get_children():
		item_container.item_selected.connect(_on_item_selected)
	_select_next_item_container()

# helper functions
func _select_next_item_container() -> void:
	for item_container: Node in item_container_list.get_children():
		if item_container.item:
			item_container.on_btn_pressed()
			return

func _matches_item_name(container, target_item_name: String) -> bool:
	if not container.item: return false
	return container.item.name == target_item_name

func _get_next_empty_inv_slot() -> PanelContainer:
	var item_containers: Array[Node] = item_container_list.get_children() 
	for container: PanelContainer in item_containers:
		if not container.item:
			return container
	return null

func _update_item_container(inv_item: InventoryItem) -> void:
	var item_containers: Array[Node] = item_container_list.get_children() 
	var match_container: Array[Node] = item_containers.filter(func(container): return _matches_item_name(container, inv_item.item.name))
	if match_container.size() > 0:
		match_container[0].item_count = inv_item.count
		match_container[0].update_ui()

func _add_new_item_container(inv_item: InventoryItem) -> void:
	var next_empty: PanelContainer = _get_next_empty_inv_slot()
	# TODO: handle full inv
	if not next_empty: return
	next_empty.item = inv_item.item
	next_empty.item_count = inv_item.count
	next_empty.update_ui()

# signals

# item slot signal
func _on_item_selected(item: RItem):
	item_selected.emit(item)

# input manager signal
func _on_input_manager_action_bar_pressed(number: int) -> void:
	for item_container: Node in item_container_list.get_children():
		if item_container.index == number:
			item_container.on_btn_pressed()

# inventory updated signal
func _on_inventory_manager_inventory_updated(inv_items: Array[InventoryItem]) -> void:
	var item_containers: Array[Node] = item_container_list.get_children()
	for inv_item: InventoryItem in inv_items:
		var is_new_item: bool = item_containers.filter(func(container): return _matches_item_name(container, inv_item.item.name)).size() == 0
		if is_new_item: _add_new_item_container(inv_item)
		else: _update_item_container(inv_item)

func _on_inventory_manager_item_depleted(item: RItem) -> void:
	var item_containers: Array[Node] = item_container_list.get_children()
	for container: PanelContainer in item_containers:
		if not container.item: continue
		if container.item.name == item.name:
			#BUG: Old item image stays, make sure to proper teardown
			container.item = null
			container.hide_ui()
