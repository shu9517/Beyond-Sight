extends Node2D

@export var dialogue: DialogueResource
@export var correct_code := "7619"

@onready var lock = $lock
@onready var unlock = $unlock

@onready var locker = $locker_1
@onready var unlocker = $locker_2

@onready var drive = $"../drive1"

var open := false
var player_in_range := false
var is_busy := false
var entering_code := false
var input_code := ""

@onready var label = $Label

func _ready():
	locker.visible = true
	unlocker.visible = false
	drive.visible = false
	
	label.visible = false
	lock.visible = false
	unlock.visible = false
	
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _process(_delta):
	if open:
		return
	
	if player_in_range and Input.is_action_just_pressed("interact") and not is_busy and not entering_code:
		await enter_pass()

	if entering_code:
		check_number_input()

func enter_pass():
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	is_busy = true
	player.stop_move()
	player.can_move = false

	await DialogueHelper.player(dialogue, "locker")

	open_lock()
	is_busy = false

func open_lock():
	entering_code = true
	input_code = ""
	label.visible = true
	lock.visible = true
	update_label()

func close_lock():
	entering_code = false
	label.visible = false
	unlock.visible = false
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.can_move = true

func check_number_input():
	for i in range(10):
		if Input.is_action_just_pressed(str(i)):
			if input_code.length() < 4:
				input_code += str(i)
				update_label()
	
	if input_code.length() == 4:
		await get_tree().create_timer(1.0).timeout
		submit_code()

func submit_code():
	if input_code == correct_code:
		lock.visible = false
		locker.visible = false
		unlock.visible = true
		unlocker.visible = true
		drive.visible = true
		open = true
		$Area2D.monitoring = false
		
		if drive and drive.has_method("unlock_item"):
			drive.unlock_item()
		
		await get_tree().create_timer(0.5).timeout
		close_lock()
	else:
		lock.visible = false
		input_code = ""
		close_lock()

func update_label():
	label.text = input_code

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
