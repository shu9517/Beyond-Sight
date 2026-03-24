extends Node2D

@export var target: String = "yellow"

@onready var normal = $fox
@onready var changed = $change

@export var dialogue: DialogueResource
var player_in_range := false
var is_talking := false

func _ready():
	add_to_group("color_item")
	show_normal()
	
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact") and not is_talking:
		await number()

func number():
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	player.stop_move()
	player.can_move = false
	is_talking = true

	await DialogueHelper.player(dialogue, "fox")

	player.can_move = true
	is_talking = false

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false

func apply_light_color(color_name: String):
	if color_name == target:
		show_changed()
	else:
		show_normal()

func show_normal():
	normal.visible = true
	changed.visible = false

func show_changed():
	normal.visible = false
	changed.visible = true
