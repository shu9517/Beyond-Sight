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

	if State.items.has("flash_device"):
		event(body)

func event(player):
	player.stop_move()
	player.can_move = false
	player.play_down()

	var camera = player.get_node_or_null("Camera2D")
	if camera:
		camera.shake(4,15)

	player.lie()
	await DialogueHelper.player(dialogue, "faint")
	
	player.can_move = true
	
func fade_and_change_scene(target_scene: String):
	var canvas = CanvasLayer.new()
	add_child(canvas)

	var rect = ColorRect.new()
	rect.color = Color.BLACK
	rect.modulate.a = 0.0
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(rect)

	var tween = create_tween()
	tween.tween_property(rect, "modulate:a", 1.0, 0.5)
	await tween.finished

	get_tree().change_scene_to_file(target_scene)
