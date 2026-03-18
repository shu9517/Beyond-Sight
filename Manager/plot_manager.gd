extends Node

var elvic_state = 0

func elvic_plot() -> String:
	match elvic_state:
		0: return "elvic_first_met"
		1: return "elvic_chat_1"
	return "default"
