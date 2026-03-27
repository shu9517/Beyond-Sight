extends Node2D

@onready var player = get_node_or_null("order/player")
@onready var spawn_points = get_node_or_null("SpawnPoints")
@export var cam_left := -700
@export var cam_top := -1000
@export var cam_right := 700
@export var cam_bottom := 1000

func _ready():
	player.set_camera_limits(cam_left, cam_top, cam_right, cam_bottom)
	player.modulate = Color(0.421, 0.334, 0.396, 1.0)
	$CanvasModulate.color = Color(0.329, 0.209, 0.24, 1.0)
	
	var spawn_node = null

	if GameManager.next_spawn != "" and spawn_points.has_node(GameManager.next_spawn):
		spawn_node = spawn_points.get_node(GameManager.next_spawn)
	else:
		spawn_node = spawn_points.get_node_or_null("default")

	if spawn_node == null:
		push_error("Spawn node not found: " + GameManager.next_spawn + " and no default spawn exists")
		return

	player.global_position = spawn_node.global_position
	
	GameManager.save_game(get_tree().current_scene.scene_file_path)
