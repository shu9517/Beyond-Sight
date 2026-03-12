extends CharacterBody2D

@export var move_speed : float = 50
@export var animator : AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = Input.get_vector("left", "right", "up", "down") * move_speed
	
	if velocity == Vector2.ZERO:
		animator.play("idle_down")
	else:
		animator.play("walk_down")
	
	move_and_slide()
