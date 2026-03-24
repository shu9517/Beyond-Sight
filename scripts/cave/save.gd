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

	#播放落石動畫
	if rock_anim:
		rock_anim.play("fall")

		# 畫面震動
		var camera = player.get_node_or_null("Camera2D")
		if camera:
			camera.shake(4, 15)

		await rock_anim.animation_finished

	#NPC 從外面出現
	if npc and spawn_point:
		npc.global_position = spawn_point.global_position
		npc.show()

	#NPC 大叫
	await DialogueHelper.elvic(dialogue, "save")

	#NPC 跑過來
	if npc and walk0:
		await npc.move_to_point(walk0.global_position)

	#恢復控制
	player.can_move = true
	if npc:
		npc.can_interact = true
