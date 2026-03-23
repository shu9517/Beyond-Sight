extends Area2D

@export var item_id: String
var player_in_range := false

func _ready():
	if State.has_item(item_id):
		queue_free()
		return

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		collect_item()

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false

func collect_item():
	State.add_item(item_id)
	GameManager.save_game(get_tree().current_scene.scene_file_path)
	print("Picked up:", item_id)
	queue_free()
