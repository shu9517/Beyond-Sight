extends Node2D

@onready var player = get_node_or_null("order/player")
@onready var npc = $order/Elvic
@onready var spawn_points = get_node_or_null("SpawnPoints")
@export var cam_left := -1850
@export var cam_top := -1950
@export var cam_right := 1850
@export var cam_bottom := 1950
@export var dialogue: DialogueResource

func _ready():
	player.set_camera_limits(cam_left, cam_top, cam_right, cam_bottom)
	
	if GameManager.has_flag("left_vill") and not GameManager.has_flag("return_vill"):
		npc.hide()
		npc.can_interact = false
		npc.collision_enabled(false)
	else:
		npc.show()
		npc.can_interact = true
		npc.collision_enabled(true)
	
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
