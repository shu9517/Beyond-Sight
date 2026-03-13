extends Node2D
@onready var dialog = get_tree().current_scene.get_node("DialogUI")

var player_in_range = false

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		if dialog.active:
			dialog.next_line()
		else:
			dialog.start_dialog([
				"It's an angle statue.",
				"Half of the wings is broke.",
				"It has something write on it...",
				"\"Guarding the truth,",
				"Holding the hope,",
				"Immortality is all alone.\""
			])

func interact():
	print("一個雕像")

func _on_body_entered(body):
	if body.name == "player":
		player_in_range = true
		print("player in range")

func _on_body_exited(body):
	if body.name == "player":
		player_in_range = false
		print("player left")
