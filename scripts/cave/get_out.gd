extends Area2D

var triggered := false
@export var dialogue: DialogueResource

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if triggered:
		return
	if not body.is_in_group("player"):
		return

	triggered = true

	event(body)

func event(player):
	player.stop_move()
	player.can_move = false

	var camera = player.get_node_or_null("Camera2D")
	if camera:
		camera.shake(4,15)

	await DialogueHelper.player(dialogue, "get_out")
	player.can_move = true
	
