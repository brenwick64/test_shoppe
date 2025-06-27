class_name Pickup
extends Node2D

@export var item_data: RItem

## behaviors
@onready var arc_move_on_spawn:Node2D = $Behaviors/ArcMoveOnSpawn
## collisions
@onready var pickup_collision:CollisionShape2D = $PickupArea/CollisionShape2D
## timers
@onready var pickup_delay:Timer = $PickupDelay

var start_pos:Vector2
var end_pos:Vector2

func _ready():
	# TODO: Replace with tilemanager call?
	arc_move_on_spawn.start_pos = start_pos
	arc_move_on_spawn.end_pos = end_pos

# step 1 - trigger pickup delay after spawn animation
func _on_arc_move_on_spawn_arc_motion_finished():
	pickup_delay.start()

# step 2 - enable collisions after pickup delay
func _on_pickup_delay_timeout():
	pickup_collision.disabled = false

# step 3 -send item info to inventory manager
func _on_pickup_area_area_entered(area):
	var inventory_manager: InventoryManager = get_tree().get_first_node_in_group("Inventory")
	if not inventory_manager: return
	inventory_manager.add_item(item_data)
	queue_free()
