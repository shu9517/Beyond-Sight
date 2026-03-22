extends Area2D

@export var player_path: NodePath
@export var npc_path: NodePath
@export var npc2_path: NodePath
@export var walk_0: NodePath
@export var walk_1: NodePath
@export var walk_2: NodePath
@export var walk_3: NodePath
@export var leave_1: NodePath
@export var spawn_path: NodePath
@export var dialogue_resource: DialogueResource

var triggered := false

@onready var player = get_node_or_null(player_path)
@onready var npc = get_node_or_null(npc_path)
@onready var npc2 = get_node_or_null(npc_path)
@onready var walk0 = get_node_or_null(walk_0)
@onready var walk1 = get_node_or_null(walk_1)
@onready var walk2 = get_node_or_null(walk_2)
@onready var walk3 = get_node_or_null(walk_3)
@onready var leave1 = get_node_or_null(leave_1)
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
	if not GameManager.has_flag("luke_met_finished"):
		player.play_up()
		await EventManager.first_met_luke(
			player,
			npc,
			dialogue_resource,
			spawn_point.global_position,
			walk0.global_position,
			walk1.global_position,
			walk2.global_position,
			walk3.global_position,
			leave1.global_position
		)
		npc.hide()
		npc.can_interact = false
		npc.collision_enabled(false)
