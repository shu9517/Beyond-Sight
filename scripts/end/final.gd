extends Node2D

@onready var player = get_node_or_null("order/player")
@onready var npc = $order/Elvic
@onready var spawn_points = get_node_or_null("SpawnPoints")

@onready var stand = $SpawnPoints/stand

@export var dialogue: DialogueResource

@export var cam_left := -900
@export var cam_top := -910
@export var cam_right := 893
@export var cam_bottom := 986

func _ready():
	var spawn_node = null
	player.set_camera_limits(cam_left, cam_top, cam_right, cam_bottom)
	player.modulate = Color(0.367, 0.634, 0.644, 1.0)
	$CanvasModulate.color = Color(0.25, 0.3, 0.5)
	
	if State.friend:
		PlotManager.elvic_state = 3
	else:
		npc.hide()
		npc.can_interact = false
		npc.collision_enabled(false)

	if GameManager.next_spawn != "" and spawn_points.has_node(GameManager.next_spawn):
		spawn_node = spawn_points.get_node(GameManager.next_spawn)
	else:
		spawn_node = spawn_points.get_node_or_null("default")
	
	if spawn_node == null:
		push_error("Spawn node not found: " + GameManager.next_spawn + " and no default spawn exists")
		return

	player.global_position = spawn_node.global_position
	
	GameManager.save_game(get_tree().current_scene.scene_file_path)
