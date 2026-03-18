extends CharacterBody2D

@export var move_speed: float = 100
@onready var animator: AnimatedSprite2D = $AnimatedSprite2D

var last_direction = Vector2.DOWN
var can_move := true #玩家可移動


func _ready():
	add_to_group("player")

func _physics_process(_delta: float) -> void:
	#can_move=false時強制暫停
	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	velocity = Input.get_vector("left", "right", "up", "down") * move_speed
	var direction = velocity
	move_and_slide()

	if direction != Vector2.ZERO:
		last_direction = direction
		play_walk(direction)
	else:
		play_idle()

func play_walk(dir: Vector2):
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

func play_get_up():
	animator.play("get_up")
	await animator.animation_finished
	play_idle()
	
func lie_down():
	animator.play("lie_down")
	await animator.animation_finished
	play_idle()

func face_target(target: Node2D):
	var dir = target.global_position - global_position
	last_direction = dir

	if abs(dir.x) > abs(dir.y):
		if dir.x < 0:
			animator.play("idle_left")
		else:
			animator.play("idle_right")
	else:
		if dir.y < 0:
			animator.play("idle_up")
		else:
			animator.play("idle_down")
