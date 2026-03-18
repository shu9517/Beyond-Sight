extends Node

var story_flags := {}
var next_spawn: String = ""

func set_flag(flag: String):
	story_flags[flag] = true

func has_flag(flag: String) -> bool:
	return story_flags.get(flag, false)
