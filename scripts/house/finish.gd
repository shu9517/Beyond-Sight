extends Area2D

var triggered := false
var player_in_range := false
@export var dialogue: DialogueResource

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta):
	if triggered:
		return
	
	if player_in_range and State.has_item("drive1"):
		triggered = true
		var player = get_tree().get_first_node_in_group("player")
		if player:
			await event(player)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false

func event(player):
	player.stop_move()
	player.can_move = false
	player.play_down()
	player.lie()
	State.get_drive1 = true

	await fade()
	await DialogueHelper.player(dialogue, "back")
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://scenes/collapse.tscn")

func fade():
	var canvas = CanvasLayer.new()
	add_child(canvas)

	var rect = ColorRect.new()
	rect.color = Color.BLACK
	rect.modulate.a = 0.0
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(rect)

	var tween = create_tween()
	tween.tween_property(rect, "modulate:a", 1.0, 5.0)
	await tween.finished
