extends Node

var current_event := ""

#主要是強制劇情動畫
func play_opening(player, npc, entrance_point, dialogue_resource: DialogueResource):
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

	# NPC 先講話，講完才會往下走
	await DialogueHelper.elvic(dialogue_resource, "opening")

	# 停一下，讓轉回去看起來自然
	await get_tree().create_timer(0.15).timeout

	player.can_move = true
	npc.can_interact = true

	GameManager.set_flag("opening_finished")
	current_event = ""
