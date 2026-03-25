extends Node


func test():
	GameManager.set_flag("opening_finished")
	State.after_collapse = true
	GameManager.set_flag("return_mon")
	PlotManager.elvic_state = 1
	PlotManager.luke_state = 1
	State.add_item("flash_device")
