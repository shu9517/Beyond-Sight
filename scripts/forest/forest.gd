extends Node2D

@onready var player = get_node_or_null("player")
@onready var spawn_points = get_node_or_null("SpawnPoints")

@onready var portal = $portal_house

@export var cam_left := -700
@export var cam_top := -700
@export var cam_right := 700
@export var cam_bottom := 700

func _ready():
	print("get_drive1 =", State.get_drive1)
	
	Test.test()

	player.modulate = Color(0.047, 0.18, 0.286, 1.0)
	player.set_camera_limits(cam_left, cam_top, cam_right, cam_bottom)

	if State.get_drive1:
		portal.monitoring = false
		portal.monitorable = false
		$portal_house/CollisionShape2D.disabled = true
		portal.visible = false

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
