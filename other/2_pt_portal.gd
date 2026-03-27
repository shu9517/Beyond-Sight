extends Area2D

@export var target_scene: String
@export var spawn_before: String = "PointA"
@export var spawn_after: String = "PointB"
@export var flag: String = "drive2"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	if GameManager.has_flag(flag):
		GameManager.next_spawn = spawn_after
	else:
		GameManager.next_spawn = spawn_before

	call_deferred("scene")

func scene():
	get_tree().change_scene_to_file(target_scene)
