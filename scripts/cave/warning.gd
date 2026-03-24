extends Node2D

@export var dialogue_resource: DialogueResource

var player_in_range := false
var is_talking := false

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	
	#State.add_item("flash_device")

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact") and not is_talking:
		await inter()

func inter():
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	player.stop_move()
	player.can_move = false
	is_talking = true
	
	if State.flashlight_on:
		await DialogueHelper.player(dialogue_resource, "sign_light")
	else:
		await DialogueHelper.player(dialogue_resource, "sign_dark")

	player.can_move = true
	is_talking = false

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
