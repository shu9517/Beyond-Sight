extends Node2D

@export var dialogue_resource: DialogueResource
@onready var player = get_tree().get_first_node_in_group("player")

var player_in_range := false
var is_talking := false

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact") and not is_talking:
		start_statue_dialogue()

func start_statue_dialogue():
	player.can_move = false
	is_talking = true
	
	var balloon = DialogueManager.show_dialogue_balloon(dialogue_resource, "statue")
	if balloon:
		balloon.tree_exited.connect(_on_dialogue_closed)

func _on_dialogue_closed():
	player.can_move = true
	is_talking = false

func _on_body_entered(body):
	if body.name == "player":
		player_in_range = true

func _on_body_exited(body):
	if body.name == "player":
		player_in_range = false
