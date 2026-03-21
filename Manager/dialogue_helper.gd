extends Node

var elvic_balloon = preload("res://character/Elvic/Elvic_textbox.tscn")
var player_balloon = preload("res://character/player/player_textbox.tscn")
var luke_balloon = preload("res://character/npc/Luke/Luke_textbox.tscn")
var chat_balloon = preload("res://Dialog/balloon.tscn")


func elvic(dialogue_resource: DialogueResource, title: String):
	var balloon = elvic_balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	await balloon.start(dialogue_resource, title)
	await balloon.tree_exited


func player(dialogue_resource: DialogueResource, title: String):
	var balloon = player_balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	await balloon.start(dialogue_resource, title)
	await balloon.tree_exited

func luke(dialogue_resource: DialogueResource, title: String):
	var balloon = luke_balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	await balloon.start(dialogue_resource, title)
	await balloon.tree_exited
	
func chat(dialogue_resource: DialogueResource, title: String):
	var balloon = chat_balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	await balloon.start(dialogue_resource, title)
	await balloon.tree_exited
