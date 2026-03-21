extends Node2D

@onready var player = get_node_or_null("order/player")
@onready var npc = $order/Elvic
@onready var spawn_points = get_node_or_null("SpawnPoints")

@export var dialogue: DialogueResource

@export var cam_left := -900
@export var cam_top := -910
@export var cam_right := 893
@export var cam_bottom := 986

func _ready():
	var spawn_node = null
	player.set_camera_limits(cam_left, cam_top, cam_right, cam_bottom)

	if not GameManager.has_flag("opening_finished"):
		await EventManager.play_opening(player, npc, dialogue)
	else:
		player.can_move = true
		npc.can_interact = true

	if GameManager.has_flag("left_mon") and not GameManager.has_flag("return_mon"):
		npc.hide()
		npc.can_interact = false
		npc.collision_enabled(false)
	else:
		npc.show()
		npc.can_interact = true
		npc.collision_enabled(true)

	if GameManager.next_spawn != "" and spawn_points.has_node(GameManager.next_spawn):
		spawn_node = spawn_points.get_node(GameManager.next_spawn)
	else:
		spawn_node = spawn_points.get_node_or_null("default")

	if spawn_node == null:
		push_error("Spawn node not found: " + GameManager.next_spawn + " and no default spawn exists")
		return

	player.global_position = spawn_node.global_position
