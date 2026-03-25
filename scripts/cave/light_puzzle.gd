extends Node2D

@onready var player = get_node_or_null("player")
@onready var spawn_points = get_node_or_null("SpawnPoints")
@export var cam_left := -700
@export var cam_top := -1000
@export var cam_right := 700
@export var cam_bottom := 1000

@onready var portal1 = $pt3

func _ready():
	player.modulate = Color(0.293, 0.257, 0.208, 1.0)
	player.set_camera_limits(cam_left, cam_top, cam_right, cam_bottom)
	
	if State.loop_ctr == 3:
		portal1.monitoring = false
		portal1.monitorable = false
		$pt3/CollisionShape2D.disabled = true
		portal1.visible = false
	
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
