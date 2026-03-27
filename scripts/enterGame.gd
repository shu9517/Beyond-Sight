extends Node2D
@export var dialogue: DialogueResource

# Called when the node enters the scene tree for the first time.
func _ready():
	if State.destory:
		await DialogueHelper.me(dialogue, "destory")
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	if State.friend:
		await DialogueHelper.me(dialogue, "happy_end")
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
		
	await DialogueHelper.me(dialogue, "start")
	fade()
	await get_tree().create_timer(5.0).timeout
	await DialogueHelper.me(dialogue, "Choice")
	await get_tree().create_timer(3.0).timeout
	call_deferred("scene")

func scene():
	get_tree().change_scene_to_file("res://scenes/monument.tscn")
	GameManager.set_flag("Start")

func fade():
	var canvas = CanvasLayer.new()
	add_child(canvas)

	var rect = ColorRect.new()
	rect.color = Color.BLACK
	rect.modulate.a = 0.0
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(rect)

	var tween = create_tween()
	tween.tween_property(rect, "modulate:a", 1.0, 5)
	await tween.finished
