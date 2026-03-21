extends Node2D

@onready var player = get_node_or_null("order/player")
@onready var spawn_points = get_node_or_null("SpawnPoints")
@export var cam_left := -500
@export var cam_top := -800
@export var cam_right := 500
@export var cam_bottom := 680

func _ready():
	player.set_camera_limits(cam_left, cam_top, cam_right, cam_bottom)
	
	var spawn_node = null
	if GameManager.next_spawn != "" and spawn_points.has_node(GameManager.next_spawn):
		spawn_node = spawn_points.get_node(GameManager.next_spawn)
	else:
		spawn_node = spawn_points.get_node_or_null("default")

	if spawn_node == null:
		push_error("Spawn node not found: " + GameManager.next_spawn + " and no default spawn exists")
		return
	player.global_position = spawn_node.global_position
