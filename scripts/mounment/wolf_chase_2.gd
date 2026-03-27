extends Area2D

var triggered := false
var player_in_range := false
var can_trigger := false

@export var dialogue: DialogueResource
@onready var wolf_anim = $wolf

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if triggered:
		return

	if body.is_in_group("player"):
		player_in_range = true
		
		if can_trigger and State.items.has("drive2"):
			triggered = true
			await event(body)

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		can_trigger = true

func event(player):
	player.velocity = Vector2.ZERO
	player.can_move = false

	if wolf_anim:
		wolf_anim.play("catch")
		await wolf_anim.animation_finished

	player.lie()
	await fade()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/end/after_mill.tscn")
	
	GameManager.set_flag("wolf_catch")

func fade():
	var canvas = CanvasLayer.new()
	add_child(canvas)

	var rect = ColorRect.new()
	rect.color = Color.BLACK
	rect.modulate.a = 0.0
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(rect)

	var tween = create_tween()
	tween.tween_property(rect, "modulate:a", 1.0, 1.0)
	await tween.finished
