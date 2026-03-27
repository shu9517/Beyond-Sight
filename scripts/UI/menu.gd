extends Control

@export var first_scene: String = "res://scenes/me.tscn"
@export var first_spawn: String = "default"

func _ready():
	$VBoxContainer/NewGame.pressed.connect(_on_new_game_pressed)
	$VBoxContainer/Load.pressed.connect(_on_load_pressed)
	$VBoxContainer/Quit.pressed.connect(_on_exit_pressed)

	$VBoxContainer/Load.disabled = not GameManager.has_save()

func _on_new_game_pressed():
	GameManager.start_new_game(first_scene, first_spawn)

func _on_load_pressed():
	GameManager.load_game()

func _on_exit_pressed():
	get_tree().quit()
