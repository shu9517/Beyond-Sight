extends Node

var elvic_balloon = preload("res://character/Elvic/Elvic_textbox.tscn")
var player_balloon = preload("res://character/player/player_textbox.tscn")
var luke_balloon = preload("res://character/npc/Luke/Luke_textbox.tscn")
var akira_balloon = preload("res://character/npc/Akira/Akira_textbox.tscn")
var npc_balloon = preload("res://character/npc/NPC_textbox.tscn")
var me_balloon = preload("res://character/me_textbox.tscn")

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

func akira(dialogue_resource: DialogueResource, title: String):
	var balloon = akira_balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	await balloon.start(dialogue_resource, title)
	await balloon.tree_exited
	
func npc(dialogue_resource: DialogueResource, title: String):
	var balloon = npc_balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	await balloon.start(dialogue_resource, title)
	await balloon.tree_exited

func me(dialogue_resource: DialogueResource, title: String):
	var balloon = me_balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	await balloon.start(dialogue_resource, title)
	await balloon.tree_exited
