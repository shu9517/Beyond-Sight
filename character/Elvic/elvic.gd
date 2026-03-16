extends CharacterBody2D

@export var dialogue_resource: DialogueResource
@onready var click_area: Area2D = get_node_or_null("Area2D")
@onready var animator: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D")

var can_interact := false
var is_talking := false
var player_in_range := false
var saved_animation := ""

func _ready():
	if click_area != null:
		click_area.body_entered.connect(_on_body_entered)
		click_area.body_exited.connect(_on_body_exited)

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact") and not is_talking:
		interact()

func interact():
	if not can_interact or is_talking:
		return

	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	player.can_move = false
	is_talking = true
	saved_animation = animator.animation

	face_target(player)
	player.face_target(self)

	await DialogueHelper.elvic(dialogue_resource, "elvic_first_met")

	player.can_move = true
	is_talking = false

func move_to_point(target_pos: Vector2):
	var speed = 120

	while global_position.distance_to(target_pos) > 5:
		var dir = (target_pos - global_position).normalized()
		velocity = dir * speed
		move_and_slide()
		await get_tree().physics_frame

	velocity = Vector2.ZERO

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

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false

func face_left():
	animator.play("idle_left")
	await animator.animation_finished
