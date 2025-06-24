extends PanelContainer

signal item_selected(item: RItem)

@export var item_btn: Button
@export var key_label: Label
@export var circle_panel: Panel

@export var index: int
@export var item: RItem
@export var item_count: int = 0

func _ready() -> void:
	item_btn.pressed.connect(on_btn_pressed)
	key_label.text = str(index)
	if item: update_ui()
	else: hide_ui()

# methods
func hide_ui() -> void:
	item_btn.visible = false
	circle_panel.visible = false
	
func show_ui() -> void:
	item_btn.visible = true
	circle_panel.visible = true

func update_ui() -> void:
	var has_item_img: bool = item_btn.get_child_count() > 0
	if not has_item_img:
		var icon: TextureRect = item.icon_scene.instantiate()
		item_btn.add_child(icon)
	
	var item_count_label: Label = circle_panel.get_node_or_null("ItemCount")
	item_count_label.text = str(item_count)
	show_ui()

func on_btn_pressed() -> void:
	if not item: return
	item_btn.grab_focus()
	item_selected.emit(item)
	item_btn.focus_mode = Control.FOCUS_ALL
