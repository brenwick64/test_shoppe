extends Node2D

@export var tile_matrix: Array[Vector2]

@onready var placement_area: Area2D = $PlacementArea
@onready var sprite_2d: Sprite2D = $Sprite2D

var tile_global_pos: Vector2
var is_valid_placement: bool = true

func valid_sprite():
	sprite_2d.modulate = Color(1, 1, 1, 0.5)
	is_valid_placement = true

func invalid_sprite():
	sprite_2d.modulate = Color(0.941176, 0.501961, 0.501961, 0.5)
	is_valid_placement = false

func _ready() -> void:
	sprite_2d.modulate = Color(1, 1, 1, 0.5)
	placement_area.area_entered.connect(_on_placement_area_area_entered)	
	placement_area.area_exited.connect(_on_placement_area_area_exited)	

func _on_placement_area_area_entered(_area: Area2D) -> void:
	invalid_sprite()

func _on_placement_area_area_exited(_area: Area2D) -> void:
	valid_sprite()
