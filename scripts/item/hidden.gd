extends StaticBody2D

enum RevealMode {
	VANISH_ON_FLASHLIGHT,
	APPEAR_ON_FLASHLIGHT
}

@export var reveal_mode: RevealMode = RevealMode.VANISH_ON_FLASHLIGHT

var triggered := false

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

func _ready():
	add_to_group("trigger_objects")
	apply_initial_state()

func apply_initial_state():
	match reveal_mode:
		RevealMode.VANISH_ON_FLASHLIGHT:
			sprite.visible = true
			collision.disabled = false

		RevealMode.APPEAR_ON_FLASHLIGHT:
			sprite.visible = false
			collision.disabled = true

func trigger_by_flashlight():
	if triggered:
		return

	triggered = true

	match reveal_mode:
		RevealMode.VANISH_ON_FLASHLIGHT:
			sprite.visible = false
			collision.disabled = true

		RevealMode.APPEAR_ON_FLASHLIGHT:
			sprite.visible = true
			collision.disabled = false
