extends Node

var elvic_balloon = preload("res://character/Elvic/Elvic_textbox.tscn")
var player_balloon = preload("res://character/player/player_textbox.tscn")


func elvic(dialogue_resource: DialogueResource, title: String):
	var balloon = elvic_balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	await balloon.start(dialogue_resource, title)


func player(dialogue_resource: DialogueResource, title: String):
	var balloon = player_balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	await balloon.start(dialogue_resource, title)
