extends PanelContainer

signal placeable_selected(placeable: RPlaceable)

@onready var item_btn: Button = $MarginContainer/Panel/ItemBtn
@onready var margin_container: MarginContainer = $MarginContainer
@onready var key_label: Label = $MarginContainer/Panel/KeyLabel
@onready var circle_panel: Panel = $CirclePanel

@export var index: int
@export var placeable: RPlaceable
@export var item_count: int = 0

func _hide_ui() -> void:
	item_btn.visible = false
	circle_panel.visible = false
	
func _show_ui() -> void:
	item_btn.visible = true
	circle_panel.visible = true

func _update_ui() -> void:
	var icon: TextureRect = placeable.icon_scene.instantiate()
	item_btn.pressed.connect(on_btn_pressed)
	item_btn.add_child(icon)
	if item_count == 0:
		item_btn.disabled = true
		item_btn.mouse_filter = Control.MOUSE_FILTER_IGNORE 
		item_btn.focus_mode = Control.FOCUS_NONE
	else:
		item_btn.disabled = false
		item_btn.mouse_filter = Control.MOUSE_FILTER_STOP 
		item_btn.focus_mode = Control.FOCUS_ALL
	
func _ready() -> void:
	key_label.text = str(index)
	if placeable: _update_ui()
	else: _hide_ui()

# methods
func on_btn_pressed() -> void:
	if not placeable: return
	item_btn.grab_focus()
	placeable_selected.emit(placeable)
