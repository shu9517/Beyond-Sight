extends Node

var story_flags := {}
var next_spawn: String = ""

#event_manager check
func set_flag(flag: String):
	story_flags[flag] = true

#let scence check
func has_flag(flag: String) -> bool:
	return story_flags.get(flag, false)
