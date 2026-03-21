extends Area2D

@export var player_path: NodePath
@export var npc_path: NodePath
@export var target_to_player_path: NodePath
@export var target_leave_path: NodePath
@export var spawn_path: NodePath
@export var dialogue_resource: DialogueResource

var triggered := false

@onready var player = get_node_or_null(player_path)
@onready var npc = get_node_or_null(npc_path)
@onready var target_to_player = get_node_or_null(target_to_player_path)
@onready var target_leave = get_node_or_null(target_leave_path)
@onready var spawn_point = get_node_or_null(spawn_path)

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if triggered:
		return
	if body != player:
		return

	triggered = true
	start_cutscene()

func start_cutscene():
	if not GameManager.has_flag("cutscene_finished"):
		await EventManager.enter_village1_with_spawn_and_exit(
			player,
			npc,
			dialogue_resource,
			spawn_point.global_position,
			target_to_player.global_position,
			target_leave.global_position
		)
		npc.hide()
