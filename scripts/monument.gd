extends Node2D

@onready var player = $order/player
@onready var npc = $order/Elvic
@onready var entrance_point = $EntrancePoint
@export var dialogue: DialogueResource

@export var cam_left := -1200
@export var cam_top := -1250
@export var cam_right := 1200
@export var cam_bottom := 1250

func _ready():
	player.set_camera_limits(cam_left, cam_top, cam_right, cam_bottom)
	if not GameManager.has_flag("opening_finished"):
		await EventManager.play_opening(player, npc, entrance_point, dialogue)
	else:
		player.can_move = true
		npc.can_interact = true
		
		if GameManager.next_spawn != "" and $SpawnPoints.has_node(GameManager.next_spawn):
			player.global_position = $SpawnPoints.get_node(GameManager.next_spawn).global_position
		else:
			player.global_position = $SpawnPoints/default.global_position
