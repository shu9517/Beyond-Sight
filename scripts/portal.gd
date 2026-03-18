extends Area2D

@export var target_scene: String
@export var target_spawn: String

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		GameManager.next_spawn = target_spawn
		get_tree().change_scene_to_file(target_scene)
