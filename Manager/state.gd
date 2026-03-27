extends Node

var elvic_statue: bool = false
var monument_plot: String = "mon_fin" #代表第一幕結束

var luke_village_ask: bool = false
var luke_elvic_ask: bool = false #player ask for elvic's info

var enter_forest: bool = false #enter forest, disable the collision
var enter_dollHouse: bool = false
var enter_room: bool = false
var get_drive1: bool = false

var after_collapse: bool = false
var hit: bool = false

var items = []
var flashlight_on = false

var talk = false
var destory = false
var friend = false

#unrelate state
var project_color: String = ""
var cave: bool = false
var loop_ctr: int = 0
var box: bool = false
var enter_chuch: bool = false
var enter_fact: bool = false
var statue: bool = false

func add_item(item_id: String):
	if not items.has(item_id):
		items.append(item_id)

func has_item(item_id: String) -> bool:
	return items.has(item_id)

func remove_item(item_id: String):
	items.erase(item_id)
