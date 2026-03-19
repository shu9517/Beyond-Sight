extends Area2D

@export var target_scene: String
@export var target_spawn: String

var is_transitioning := false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if is_transitioning:
		return
		
	if body.is_in_group("player"):
		is_transitioning = true
		GameManager.next_spawn = target_spawn
		call_deferred("_go_to_target_scene")

func _go_to_target_scene():
	get_tree().change_scene_to_file(target_scene)
