extends Node2D

@onready var sprite = $Sprite2D

func _ready():
	add_to_group("hidden_objects")
	sprite.visible = false

func update_flashlight(is_on: bool):
	sprite.visible = is_on
