extends Camera2D

var shake_time := 0.0
var shake_strength := 0.0
var shake_decay := 5.0

func _process(delta):
	if shake_time > 0:
		shake_time -= delta

		var current_strength = shake_strength * (shake_time)

		offset = Vector2(
			randf_range(-1, 1),
			randf_range(-1, 1)
		) * current_strength
	else:
		offset = Vector2.ZERO

func shake(duration := 0.3, strength := 8.0):
	shake_time = duration
	shake_strength = strength
