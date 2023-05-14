extends Control


func _ready() -> void:
	var path = "res://Scenes/Levels/"
	var dir = DirAccess.open(path)
	var file_idx = 0
	for file in dir.get_files():
		var button = Button.new()
		button.text = "Level %s" % str(file_idx+1)
		if PlayerData.unlocked_levels.size() < file_idx + 1:
			button.disabled = true
		button.custom_minimum_size = Vector2(200,100)
		if file.ends_with(".remap"):
			file = file.trim_suffix(".remap")
		button.connect("pressed", level_selected.bind(path + file))
		$GridContainer.add_child(button)
		if file_idx == 0:
			button.grab_focus()
		file_idx += 1
	if PlayerData.unlocked_levels.size() == 0:
		$ConfirmationDialog.popup_centered()

func level_selected(file_path: String):
	Transition.play("end")
	await Transition.animation_finished
	get_tree().change_scene_to_file(file_path)


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_confirmation_dialog_confirmed():
	PlayerData.unlocked_levels.append(1)
	Transition.play("end")
	await Transition.animation_finished
	get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")


func _on_confirmation_dialog_canceled():
	PlayerData.unlocked_levels.append(1)
	get_tree().reload_current_scene()
