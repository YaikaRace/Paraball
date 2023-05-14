extends Control


func _ready() -> void:
	%Play.grab_focus()
	Transition.play("init")


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_selector.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_config_pressed():
	get_tree().change_scene_to_file("res://Scenes/config.tscn")


func _on_tutorial_pressed():
	if not 1 in PlayerData.unlocked_levels:
		PlayerData.unlocked_levels.append(1)
	get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")
