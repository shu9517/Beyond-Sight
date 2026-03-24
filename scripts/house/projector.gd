extends Sprite2D

@export var dialogue_resource: DialogueResource

var player_in_range := false
var is_talking := false
var color = "white"

@onready var white = $white
@onready var red = $red 
@onready var orange = $orange
@onready var yellow = $yellow
@onready var green = $green
@onready var blue = $blue
@onready var purple = $purple

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact") and not is_talking:
		await change()

func change():
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	player.stop_move()
	player.can_move = false
	is_talking = true

	await DialogueHelper.player(dialogue_resource, "projector")
	update()

	player.can_move = true
	is_talking = false

func update():
	color = State.project_color
	
	white.visible = false
	red.visible = false
	orange.visible = false
	yellow.visible = false
	green.visible = false
	blue.visible = false
	purple.visible = false
	
	match color:
		"white":
			white.visible = true
		"red":
			red.visible = true
		"orange":
			orange.visible = true
		"yellow":
			yellow.visible = true
		"green":
			green.visible = true
		"blue":
			blue.visible = true
		"purple":
			purple.visible = true
	
	get_tree().call_group("color_item", "apply_light_color", color)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
