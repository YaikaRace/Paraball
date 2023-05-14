extends CanvasLayer


func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and get_tree().current_scene.name.begins_with("level") and not WinScreen.visible and not visible:
		visible = true
		%Resume.grab_focus()
		get_tree().paused = true

func _on_resume_pressed():
	await get_tree().process_frame
	await get_tree().process_frame
	visible = false
	get_tree().paused = false

func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		visible = true
		get_tree().paused = true


func _on_menu_pressed():
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_restart_pressed():
	visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()
