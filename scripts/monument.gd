extends Node2D

@onready var player = $order/player
@onready var npc = $order/Elvic
@onready var entrance_point = $EntrancePoint

@export var dialogue: DialogueResource

func _ready():
	if not GameManager.has_flag("opening_finished"):
		await EventManager.play_opening(player, npc, entrance_point, dialogue)
	else:
		player.can_move = true
		npc.can_interact = true
