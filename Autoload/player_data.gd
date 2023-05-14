extends Node

var unlocked_levels = []

func _ready():
	load_data()

func save_data():
	var file = FileAccess.open("user://player_data.sav", FileAccess.WRITE)
	file.store_line(var_to_str(unlocked_levels))
	file.close()

func load_data():
	if FileAccess.file_exists("user://player_data.sav"):
		var file = FileAccess.open("user://player_data.sav", FileAccess.READ)
		var data = file.get_as_text()
		unlocked_levels = str_to_var(data)
		file.close()
