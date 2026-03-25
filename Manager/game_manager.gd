extends Node

var story_flags := {}
var next_spawn: String = ""

const SAVE_PATH := "user://autosave.json"

#event_manager check
func set_flag(flag: String):
	story_flags[flag] = true

#let scence check
func has_flag(flag: String) -> bool:
	return story_flags.get(flag, false)

func clear_flag(flag: String):
	story_flags.erase(flag)

func save_game(scene_path: String):
	var save_data = {
		"scene": scene_path,
		"spawn": next_spawn,
		"story_flags": story_flags,
		"state": {
			"items": State.items,
			"flashlight_on": State.flashlight_on,
			"elvic_statue": State.elvic_statue,
			"monument_plot": State.monument_plot,
			"luke_village_ask": State.luke_village_ask,
			"luke_elvic_ask": State.luke_elvic_ask,
			"enter_forest": State.enter_forest,
			"enter_dollHouse": State.enter_dollHouse,
			"enter_room": State.enter_room,
			"get_drive1": State.get_drive1,
			"after_collapse": State.after_collapse,
			"box": State.box,
			"hit": State.hit
		},
		"plot": {
			"elvic_state": PlotManager.elvic_state,
			"luke_state": PlotManager.luke_state
		}
	}

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Failed to save game.")
		return

	file.store_string(JSON.stringify(save_data))
	file.close()
	print("Game saved.")

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found.")
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("Failed to open save file.")
		return

	var content = file.get_as_text()
	file.close()

	var data = JSON.parse_string(content)
	if data == null:
		push_error("Save file is corrupted.")
		return

	story_flags = data.get("story_flags", {})
	next_spawn = data.get("spawn", "")

	var state_data = data.get("state", {})
	State.items = state_data.get("items", [])
	State.flashlight_on = state_data.get("flashlight_on", false)
	State.elvic_statue = state_data.get("elvic_statue", false)
	State.monument_plot = state_data.get("monument_plot", "mon_fin")
	State.luke_village_ask = state_data.get("luke_village_ask", false)
	State.luke_elvic_ask = state_data.get("luke_elvic_ask", false)
	State.enter_forest = state_data.get("enter_forest", false)
	State.enter_dollHouse = state_data.get("enter_dollHouse", false)
	State.enter_room = state_data.get("enter_room", false)
	State.get_drive1 = state_data.get("get_drive1", false)
	State.after_collapse = state_data.get("after_collapse", false)
	State.box = state_data.get("box", false)
	State.hit = state_data.get("hit", false)

	var plot_data = data.get("plot", {})
	PlotManager.elvic_state = plot_data.get("elvic_state", 0)
	PlotManager.luke_state = plot_data.get("luke_state", 0)

	var scene_path = data.get("scene", "")
	if scene_path != "":
		get_tree().change_scene_to_file(scene_path)

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func delete_save():
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
		print("Save deleted.")

func reset_all_data():
	story_flags.clear()
	next_spawn = ""

	State.items = []
	State.flashlight_on = false
	State.elvic_statue = false
	State.monument_plot = "mon_fin"
	State.luke_village_ask = false
	State.luke_elvic_ask = false
	State.enter_forest = false
	State.enter_dollHouse = false
	State.enter_room = false
	State.get_drive1 = false
	State.after_collapse = false
	State.box = false
	State.hit = false

	PlotManager.elvic_state = 0
	PlotManager.luke_state = 0

func start_new_game(first_scene: String, first_spawn: String = "default"):
	delete_save()
	reset_all_data()
	next_spawn = first_spawn
	get_tree().change_scene_to_file(first_scene)
