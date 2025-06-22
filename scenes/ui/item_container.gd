extends MarginContainer

signal placeable_selected(placeable: RPlaceable)

@onready var item_btn: Button = $PanelContainer/ItemBtn
@onready var panel_container: PanelContainer = $PanelContainer
@onready var key_label: Label = $PanelContainer/MarginContainer/KeyLabel

@export var index: int
@export var placeable: RPlaceable

func _hide_ui() -> void:
	item_btn.visible = false

func _show_ui() -> void:
	item_btn.visible = true

func _update_ui() -> void:
	var icon: TextureRect = placeable.icon_scene.instantiate()
	item_btn.pressed.connect(on_btn_pressed)
	item_btn.add_child(icon)

func _ready() -> void:
	key_label.text = str(index)
	if placeable: _update_ui()
	else: _hide_ui()

# methods
func on_btn_pressed() -> void:
	if not placeable: return
	item_btn.grab_focus()
	placeable_selected.emit(placeable)
