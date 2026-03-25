extends Area2D

var triggered := false

@export var dialogue: DialogueResource
@export var spawn_path: NodePath
@export var walk_0: NodePath
@export var npc_path: NodePath

@onready var npc = get_node_or_null(npc_path)
@onready var walk0 = get_node_or_null(walk_0)
@onready var spawn_point = get_node_or_null(spawn_path)
@onready var rock_anim = $rock

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if triggered:
		return
	if not body.is_in_group("player"):
		return

	triggered = true
	await event(body)

func event(player):
	#玩家停住
	player.stop_move()
	player.can_move = false
	
	if npc:
		npc.can_interact = false
		
	#NPC 從外面出現
	if npc and spawn_point:
		npc.global_position = spawn_point.global_position
		npc.show()

	#NPC 大叫
	await DialogueHelper.elvic(dialogue, "save")
	
	#播放落石動畫
	if rock_anim:
		rock_anim.play("fall")

		# 畫面震動
		var camera = player.get_node_or_null("Camera2D")
		if camera:
			camera.shake(4, 15)

		player.lie()
		fade()
		await rock_anim.animation_finished

	#NPC 跑過來
	if npc and walk0:
		await npc.move_to_point(walk0.global_position)
	
	State.after_collapse = true
	GameManager.set_flag("return_mon")
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://scenes/church.tscn")
	#恢復控制
	if npc:
		npc.can_interact = true

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
