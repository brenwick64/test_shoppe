extends Panel

signal placeable_selected(placeable: RPlaceable)

@onready var h_box_container: HBoxContainer = $HBoxContainer

func _ready() -> void:
	for item_container: Node in h_box_container.get_children():
		item_container.placeable_selected.connect(_on_placeable_selected)

func _on_input_manager_action_bar_pressed(number: int) -> void:
	for item_container: Node in h_box_container.get_children():
		if item_container.index == number:
			item_container.on_btn_pressed()

func _on_placeable_selected(placeable: RPlaceable):
	placeable_selected.emit(placeable)
