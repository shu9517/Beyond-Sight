extends CanvasLayer

@onready var text_label = $TextureRect/content

var lines = []
var index = 0
var active = false

func _ready():
	visible = false

func start_dialog(dialog_lines):
	lines = dialog_lines
	index = 0
	active = true
	visible = true
	text_label.text = lines[index]

func next_line():
	index += 1
	
	if index >= lines.size():
		end_dialog()
	else:
		text_label.text = lines[index]

func end_dialog():
	active = false
	visible = false
