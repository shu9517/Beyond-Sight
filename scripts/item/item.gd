extends Area2D

@export var item_id: String
@export var need_lock: bool = false
@export var dialogue: DialogueResource
@export var dialogue_tag: String = "pickup"

var player_in_range := false
var unlocked := false
var collecting := false

func _ready():
	if State.has_item(item_id):
		queue_free()
		return

	if need_lock:
		visible = false
		monitoring = false
		monitorable = false
		$CollisionShape2D.disabled = true

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta):
	if collecting:
		return

	if player_in_range and Input.is_action_just_pressed("interact"):
		if need_lock and not unlocked:
			return
		await collect_item()

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false

func unlock_item():
	unlocked = true
	visible = true
	monitoring = true
	monitorable = true
	$CollisionShape2D.disabled = false

func collect_item():
	collecting = true

	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.stop_move()
		player.can_move = false

	if dialogue:
		await DialogueHelper.player(dialogue, dialogue_tag)

	State.add_item(item_id)
	GameManager.save_game(get_tree().current_scene.scene_file_path)
	print("Picked up:", item_id)

	if player:
		player.can_move = true

	queue_free()
