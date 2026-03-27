extends Node2D

@onready var player = get_node_or_null("player")
@onready var spawn_points = get_node_or_null("SpawnPoints")
@export var cam_left := -900
@export var cam_top := -700
@export var cam_right := 900
@export var cam_bottom := 700

@export var dialogue: DialogueResource

func _ready():
	player.set_camera_limits(cam_left, cam_top, cam_right, cam_bottom)
	player.modulate = Color(0.139, 0.259, 0.328, 1.0)
	
	if not GameManager.has_flag("wake_up_wolf"):
		player.can_move = false
		player.lie_down()
		await get_tree().create_timer(1.0).timeout
		await player.play_get_up()
		await DialogueHelper.player(dialogue, "late")
		GameManager.set_flag("wake_up_wolf")
		player.can_move = true
	else:
		player.can_move = true
	
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
