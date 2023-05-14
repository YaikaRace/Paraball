extends Node2D


func _ready():
	if not 1 in PlayerData.unlocked_levels:
		PlayerData.unlocked_levels.append(1)
	PlayerData.save_data()
	var message: String
	if OS.get_name() != "Android":
		message = "left/a and right/d arrow keys"
	else:
		message =  "left and right side of screen"
	$Control/Label.text = "You can use the %s \nand the ball will rotate 90 degrees in the \ncorresponding direction." % message
