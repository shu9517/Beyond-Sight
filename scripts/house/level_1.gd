extends Node2D
@export var dialogue: DialogueResource

@onready var player = get_node_or_null("order/player")
@onready var spawn_points = get_node_or_null("SpawnPoints")
@export var cam_left := -720
@export var cam_top := -405
@export var cam_right := 720
@export var cam_bottom := 405

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
	
	player.can_move = false
	player.lie_down()
	await get_tree().create_timer(1.0).timeout
	await player.play_get_up()
	player.play_up()
	await DialogueHelper.player(dialogue, "where")
	player.can_move = true
	
	GameManager.save_game(get_tree().current_scene.scene_file_path)
