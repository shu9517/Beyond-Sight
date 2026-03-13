extends CharacterBody2D

@export var move_speed : float = 1000
@export var animator : AnimatedSprite2D

var last_direction = Vector2.DOWN

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = Input.get_vector("left", "right", "up", "down") * move_speed
	var direction = velocity
	move_and_slide()
	
	if direction != Vector2.ZERO:
		last_direction = direction
		play_walk(direction)
	else:
		play_idle()	
	
func play_walk(dir):
	if abs(dir.x) > abs(dir.y):
		if dir.x < 0:
			animator.play("walk_left")
		else:
			animator.play("walk_right")
	else:
		if dir.y < 0:
			animator.play("walk_up")
		else:
			animator.play("walk_down")

func play_idle():
	if abs(last_direction.x) > abs(last_direction.y):
		if last_direction.x < 0:
			animator.play("idle_left")
		else:
			animator.play("idle_right")
	else:
		if last_direction.y < 0:
			animator.play("idle_up")
		else:
			animator.play("idle_down")
