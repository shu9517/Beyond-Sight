extends Node2D

@onready var player = $player
@export var cam_left := -1720
@export var cam_top := -600
@export var cam_right := 1720
@export var cam_bottom := 603

func _ready():
	player.set_camera_limits(cam_left, cam_top, cam_right, cam_bottom)

	if GameManager.next_spawn != "" and $SpawnPoints.has_node(GameManager.next_spawn):
		player.global_position = $SpawnPoints.get_node(GameManager.next_spawn).global_position
	else:
		player.global_position = $SpawnPoints/default.global_position
