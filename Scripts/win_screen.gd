extends CanvasLayer


func _ready() -> void:
	Events.win.connect(on_win)

func on_win(rank) -> void:
	$AudioStreamPlayer.play()
	var current_level = get_tree().current_scene.get_meta("level")
	if FileAccess.file_exists("res://Scenes/Levels/level_%s.tscn" % str(current_level+1)) or FileAccess.file_exists("res://Scenes/Levels/level_%s.tscn.remap" % str(current_level+1)):
		if not current_level + 1 in PlayerData.unlocked_levels:
			PlayerData.unlocked_levels.append(current_level+1)
			PlayerData.save_data()
		%Next.visible = true
		%Next.grab_focus()
	else:
		%Next.visible = false
		%Restart.grab_focus()
	visible = true
	var rank_color = "red"
	match rank:
		"S":
			rank_color = "gold"
		"A":
			rank_color = "green"
		"B":
			rank_color = "orange"
		"F":
			rank_color = "red"
	%Rank.text = "[center]Rank: [color=%s]%s" % [rank_color, rank]


func _on_restart_pressed() -> void:
	get_tree().paused = false
	visible = false
	Transition.play("end")
	await Transition.animation_finished
	get_tree().reload_current_scene()


func _on_next_pressed() -> void:
	var current_level = get_tree().current_scene.get_meta("level")
	get_tree().paused = false
	visible = false
	Transition.play("end")
	await Transition.animation_finished
	get_tree().change_scene_to_file("res://Scenes/Levels/level_%s.tscn" % str(current_level+1))


func _on_main_pressed() -> void:
	get_tree().paused = false
	visible = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
