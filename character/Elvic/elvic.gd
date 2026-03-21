extends CharacterBody2D

@export var dialogue_resource: DialogueResource
@onready var click_area: Area2D = get_node_or_null("Area2D")
@onready var animator: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D")

@export var move_speed := 500

var can_interact := true #可互動: 可
var player_in_range := false #玩家範圍內?: 沒有
var saved_animation := "" #調整站姿用

var is_moving := false
var move_target := Vector2.ZERO
var last_direction := Vector2.DOWN

func _ready():	
	if click_area != null:
		click_area.body_entered.connect(_on_body_entered) #物件進2d範圍時呼叫_on_body_entered
		click_area.body_exited.connect(_on_body_exited)

func _process(_delta):
	if player_in_range and can_interact and Input.is_action_just_pressed("interact"):
		interact()

#主要是玩家點擊時的步驟
func interact():
	saved_animation = animator.animation
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	face_target(player)
	player.face_target(self)
	
	player.stop_move()
	player.can_move = false
	can_interact = false
	
	#劇本
	await DialogueHelper.elvic(dialogue_resource, PlotManager.elvic_plot())
	
	player.can_move = true
	can_interact = true

#動畫需要
func move_to_point(pos: Vector2):
	if get_tree() == null:
		return

	move_target = pos
	is_moving = true

	while is_moving:
		var dir = move_target - global_position

		if dir.length() > 4:
			velocity = dir.normalized() * move_speed #the velocity got warning once
			global_position += velocity * get_process_delta_time()
			update_animation(velocity)
		else:
			global_position = move_target
			is_moving = false
			update_animation(Vector2.ZERO)

		if get_tree() == null:
			break
		await get_tree().process_frame

#走路動畫
func update_animation(dir: Vector2):
	if dir.length() > 0.1:
		last_direction = dir
	if dir.length() < 0.1:
		play_idle()
		return

	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			$AnimatedSprite2D.play("walk_right")
		else:
			$AnimatedSprite2D.play("walk_left")
	else:
		if dir.y > 0:
			$AnimatedSprite2D.play("walk_front")
		else:
			$AnimatedSprite2D.play("walk_back")

##idle after animation
func play_idle():
	if abs(last_direction.x) > abs(last_direction.y):
		if last_direction.x > 0:
			$AnimatedSprite2D.play("idle_right")
		else:
			$AnimatedSprite2D.play("idle_left")
	else:
		if last_direction.y > 0:
			$AnimatedSprite2D.play("idle_front")
		else:
			$AnimatedSprite2D.play("idle_back")

func play_up():
	animator.play("idle_back")

#面朝向(目前功能ok)
func face_target(target: Node2D):
	var dir = target.global_position - global_position

	if abs(dir.x) > abs(dir.y):
		if dir.x < 0:
			animator.play("idle_left")
		else:
			animator.play("idle_right")
	else:
		if dir.y < 0:
			animator.play("idle_back")
		else:
			animator.play("idle_front")

#玩家進範圍
func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

#玩家離開範圍
func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false

func face_left():
	animator.play("idle_left")
	await animator.animation_finished

func collision_enabled(enabled: bool):
	if has_node("CollisionShape2D"):
		$CollisionShape2D.disabled = !enabled

##
func move_to(pos: Vector2):
	await move_to_point(pos)
