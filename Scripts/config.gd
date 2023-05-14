extends Control


func _ready():
	%mode_opt.grab_focus()
	%mode_opt.select(ConfigHandler.config.mode_idx)
	%res_opt.select(ConfigHandler.config.res_idx)
	%master_sl.value = ConfigHandler.config.master
	%music_sl.value = ConfigHandler.config.music
	%sfx_sl.value = ConfigHandler.config.sfx


func _on_mode_opt_item_selected(index):
	ConfigHandler.config.mode_idx = index
	ConfigHandler.set_mode()


func _on_res_opt_item_selected(index):
	ConfigHandler.config.res_idx = index
	ConfigHandler.set_res()


func _on_music_sl_value_changed(value):
	ConfigHandler.config.music = value
	ConfigHandler.set_volume()


func _on_sfx_sl_value_changed(value):
	ConfigHandler.config.sfx = value
	ConfigHandler.set_volume()


func _on_master_sl_value_changed(value):
	ConfigHandler.config.master = value
	ConfigHandler.set_volume()



func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	ConfigHandler.apply_config()
