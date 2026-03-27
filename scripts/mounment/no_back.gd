extends StaticBody2D

@onready var collision = $CollisionShape2D

func _ready():
	collision.disabled = true
	if State.items.has("drive2"):
		collision.disabled = false
