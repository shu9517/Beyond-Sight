extends Node

var current_event := ""

#主要是強制劇情動畫
#player awake
func play_opening(player, npc, dialogue_resource: DialogueResource):
	current_event = "opening"

	player.can_move = false
	npc.can_interact = false
	
	player.lie_down()
	npc.face_left()

	# 玩家先起身
	await get_tree().create_timer(1.0).timeout
	await player.play_get_up()

	# 先互相面向
	npc.face_target(player)
	player.face_target(npc)

	# 讓轉身先顯示出來
	await get_tree().process_frame
	await get_tree().create_timer(0.05).timeout

	# NPC 先講話
	await DialogueHelper.elvic(dialogue_resource, "opening")

	player.can_move = true
	npc.can_interact = true

	GameManager.set_flag("opening_finished")
	current_event = ""

#第一次進trail
func enter_village1_with_spawn_and_exit(
	player,
	npc,
	dialogue_resource: DialogueResource,
	spawn_pos: Vector2,
	talk_pos: Vector2,
	exit_pos: Vector2):

	current_event = "enter_village_trail_front"

	player.stop_move()
	player.can_move = false
	npc.can_interact = false

	# 從地圖外出現
	npc.global_position = spawn_pos
	npc.show()

	# 跑進來時快一點
	npc.move_speed = 500
	await npc.move_to_point(talk_pos)

	npc.face_target(player)
	player.face_target(npc)

	await DialogueHelper.elvic(dialogue_resource, "trail_elvic")

	# 跑走也可以快一點
	npc.move_speed = 400
	await npc.move_to_point(exit_pos)

	player.can_move = true
	npc.can_interact = true

	GameManager.set_flag("cutscene_finished")
	GameManager.set_flag("left_mon")
	current_event = ""

func first_met_luke(
	player,
	npc,
	npc2,
	dialogue_resource,
	spawn_point,
	walk1,
	walk2,
	walk3):

	player.stop_move()
	player.can_move = false
	npc.can_interact = false

	# 從地圖外出現
	npc.global_position = spawn_point
	npc.show()
	npc.face_target(player)
	player.face_target(npc)
	
	await DialogueHelper.elvic(dialogue_resource, "follow")

	await auto_walk(player, npc, walk1)
	await auto_walk(player, npc, walk2)
	await auto_walk(player, npc, walk3)
	
	npc.play_up()
	player.play_up()
	await DialogueHelper.luke(dialogue_resource, "hi_to_elvic")
	await DialogueHelper.chat(dialogue_resource, "chat_with_Luke")

	player.can_move = true
	npc.can_interact = true


func auto_walk(player, npc, target_pos: Vector2, follow_distance := 28.0):
	npc.move_speed = 400
	player.move_speed = 400

	while npc.global_position.distance_to(target_pos) > 6.0:
		var npc_dir = target_pos - npc.global_position

		if npc_dir.length() > 0.1:
			npc.velocity = npc_dir.normalized() * npc.move_speed
			npc.move_and_slide()
			npc.update_animation(npc.velocity)

		var follow_target = npc.global_position - npc_dir.normalized() * follow_distance
		player.auto_move_towards(follow_target, 400.0, 12.0)

		if player.get_tree() == null or npc.get_tree() == null:
			break

		await player.get_tree().process_frame

	npc.velocity = Vector2.ZERO
	npc.update_animation(Vector2.ZERO)
	player.stop_auto_move()
