extends PanelContainer

signal item_selected(item: RItem)

@export var item_btn: Button
@export var key_label: Label
@export var circle_panel: Panel

@export var index: int
@export var inventory_item: InventoryItem

func _ready() -> void:
	item_btn.pressed.connect(on_btn_pressed)
	key_label.text = str(index)
	if inventory_item: update_ui()
	else: hide_ui()

# methods
func hide_ui() -> void:
	item_btn.visible = false
	circle_panel.visible = false
	
func show_ui() -> void:
	if not inventory_item: return
	if inventory_item.stackable:
		circle_panel.visible = true
	item_btn.visible = true

func clear_item() -> void:
	for node: Node in item_btn.get_children():
		node.queue_free()
	inventory_item = null
	hide_ui()

func update_ui() -> void:
	# add label image
	var has_item_img: bool = item_btn.get_child_count() > 0
	if not has_item_img:
		var icon: TextureRect = inventory_item.item.icon_scene.instantiate()
		item_btn.add_child(icon)
	# update label
	var item_count_label: Label = circle_panel.get_node_or_null("ItemCount")
	item_count_label.text = str(inventory_item.count)
	show_ui()

func on_btn_pressed() -> void:
	if not inventory_item: return
	item_btn.grab_focus()
	item_selected.emit(inventory_item.item)
	item_btn.focus_mode = Control.FOCUS_ALL
