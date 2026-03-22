extends Node

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
