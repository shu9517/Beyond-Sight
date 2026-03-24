extends CharacterBody2D

@export var move_speed: float = 400
@onready var animator: AnimatedSprite2D = $AnimatedSprite2D

var last_direction = Vector2.DOWN
var can_move := true #玩家可移動
var talk := false
var flashlight_on = false

@onready var light = $PointLight2D
@onready var flashlight_area = $FlashlightArea

func _ready():
	add_to_group("player")
	light.visible = false
	flashlight_area.monitoring = false

func _physics_process(_delta: float) -> void:
	# can_move=false時強制暫停
	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	velocity = Input.get_vector("left", "right", "up", "down") * move_speed
	var direction = velocity
	move_and_slide()
	
	if Input.is_action_just_pressed("flashlight") and State.items.has("flash_device"):
		flashlight_on = !flashlight_on
		light.visible = flashlight_on
		flashlight_area.monitoring = flashlight_on
		State.flashlight_on = flashlight_on
		
		# 跟著燈狀態變的物件
		get_tree().call_group("hidden_objects", "update_flashlight", flashlight_on)
		
		# 只有開燈當下才觸發一次型物件
		if flashlight_on:
			get_tree().call_group("trigger_objects", "trigger_by_flashlight")

	if direction != Vector2.ZERO:
		last_direction = direction.normalized()
		play_walk(direction)
	else:
		play_idle()
	
	light_dir()

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

func play_up():
	animator.play("idle_up")

func play_down():
	animator.play("idle_down")

func lie_down():
	animator.play("lie_down")
	await animator.animation_finished
	play_idle()

func lie():
	animator.play("lie")
	await animator.animation_finished

func stop_move():
	velocity = Vector2.ZERO
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

func set_camera_limits(left: int, top: int, right: int, bottom: int):
	$Camera2D.limit_left = left
	$Camera2D.limit_top = top
	$Camera2D.limit_right = right
	$Camera2D.limit_bottom = bottom

#Auto move
func auto_move_towards(target_pos: Vector2, follow_speed := 120.0, stop_distance := 10.0):
	var dir = target_pos - global_position

	if dir.length() <= stop_distance:
		velocity = Vector2.ZERO
		play_idle()
		move_and_slide()
		return true

	velocity = dir.normalized() * follow_speed
	
	last_direction = velocity
	play_walk(velocity)
	
	move_and_slide()
	return false

func stop_auto_move():
	velocity = Vector2.ZERO
	play_idle()
	move_and_slide()

func light_dir():
	var angle = last_direction.angle() - deg_to_rad(90)
	light.rotation = angle
	flashlight_area.rotation = angle
