extends Camera2D


func _ready():
	Events.death.connect(shake)

func shake():
	$Shaker.start()
