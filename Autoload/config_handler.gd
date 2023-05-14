extends Node

var config = {
	mode_idx = 0,
	res_idx  = 0,
	master = 1,
	music = 1,
	sfx = 1
}

func _ready():
	load_cfg()

func set_mode() -> void:
	match config.mode_idx:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func set_res() -> void:
	match config.res_idx:
		0:
			DisplayServer.window_set_size(Vector2(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2(1366, 768))
		2:
			DisplayServer.window_set_size(Vector2(1280, 720))
		3:
			DisplayServer.window_set_size(Vector2(960, 540))
		4:
			DisplayServer.window_set_size(Vector2(854, 480))
		5:
			DisplayServer.window_set_size(Vector2(640, 360))
		6:
			DisplayServer.window_set_size(Vector2(426, 240))

func set_volume() -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(config.master))
	AudioServer.set_bus_volume_db(1, linear_to_db(config.music))
	AudioServer.set_bus_volume_db(2, linear_to_db(config.sfx))

func apply_config() -> void:
	set_mode()
	set_res()
	set_volume()
	save_cfg()

func save_cfg():
	var file = FileAccess.open("user://config.conf", FileAccess.WRITE)
	file.store_line(var_to_str(config))
	file.close()

func load_cfg():
	if FileAccess.file_exists("user://config.conf"):
		var file = FileAccess.open("user://config.conf", FileAccess.READ)
		var cfg = file.get_as_text()
		config = str_to_var(cfg)
		file.close()
		apply_config()

