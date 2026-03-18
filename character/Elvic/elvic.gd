extends CharacterBody2D

@export var dialogue_resource: DialogueResource
@onready var click_area: Area2D = get_node_or_null("Area2D")
@onready var animator: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D")

var can_interact := true #可互動: 可
var player_in_range := false #玩家範圍內?: 沒有
var saved_animation := "" #調整站姿用

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
	
	player.can_move = false
	can_interact = false
	
	#劇本
	await DialogueHelper.elvic(dialogue_resource, PlotManager.elvic_plot())
	
	player.can_move = true
	can_interact = true

#動畫需要
func move_to_point(target_pos: Vector2):
	var speed = 120

	while global_position.distance_to(target_pos) > 5:
		var dir = (target_pos - global_position).normalized()
		velocity = dir * speed
		move_and_slide()
		await get_tree().physics_frame

	velocity = Vector2.ZERO

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
