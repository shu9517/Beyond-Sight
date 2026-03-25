extends Node2D

@export var dialogue_resource: DialogueResource

@export var target_scene: String
@export var target_spawn: String

var player_in_range := false
var is_talking := false

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact") and not is_talking:
		await start_statue_dialogue()

func start_statue_dialogue():
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	player.stop_move()
	player.can_move = false
	is_talking = true

	await DialogueHelper.player(dialogue_resource, "enter")

	player.can_move = true
	is_talking = false
	
	if State.enter_fact == true:
		GameManager.next_spawn = target_spawn
		State.enter_fact = false
		call_deferred("_go_to_target_scene")

func _go_to_target_scene():
	get_tree().change_scene_to_file(target_scene)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
