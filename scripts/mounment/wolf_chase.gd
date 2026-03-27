extends Area2D

var triggered := false
var player_in_range := false

@export var dialogue: DialogueResource
@onready var wolf_anim = $wolf

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false

func _process(_delta):
	if triggered:
		return
	
	if player_in_range and State.items.has("drive2"):
		triggered = true
		var player = get_tree().get_first_node_in_group("player")
		await event(player)

func event(player):
	player.velocity = Vector2.ZERO
	player.can_move = false
	player.play_up()
	await get_tree().create_timer(0.2).timeout
	
	var camera = player.get_node_or_null("Camera2D")
	if camera:
		camera.shake(4, 15)

	await DialogueHelper.player(dialogue, "what")

	if wolf_anim:
		wolf_anim.play("stand")
		await wolf_anim.animation_finished

	await DialogueHelper.player(dialogue, "run")

	player.play_down()
	await step_back(player)
	
	GameManager.set_flag("wolf")
	
func step_back(player):
	var duration = 20
	var speed = 600

	player.can_move = false
	
	var time := 0.0
	while time < duration:
		player.velocity = Vector2.DOWN * speed
		player.play_down()
		
		player.move_and_slide()
		await get_tree().physics_frame
		
		time += get_physics_process_delta_time()
	
	player.velocity = Vector2.ZERO
	player.can_move = true
