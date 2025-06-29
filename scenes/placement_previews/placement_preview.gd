extends Node2D

@onready var placement_area: Area2D = $PlacementArea
@onready var sprite_2d: Sprite2D = $Sprite2D

var is_valid_placement: bool = true

func _ready() -> void:
	sprite_2d.modulate = Color(1, 1, 1, 0.5)
	placement_area.area_entered.connect(_on_placement_area_area_entered)	
	placement_area.area_exited.connect(_on_placement_area_area_exited)	

func _on_placement_area_area_entered(area: Area2D) -> void:
	sprite_2d.modulate = Color(0.941176, 0.501961, 0.501961, 0.5)
	is_valid_placement = false

func _on_placement_area_area_exited(area: Area2D) -> void:
	sprite_2d.modulate = Color(1, 1, 1, 0.5)
	is_valid_placement = true
