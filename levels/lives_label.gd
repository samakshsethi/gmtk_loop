extends Label

func _ready() -> void:
	text = "Lives: " + str(Globals.lives)
	
func _process(delta):
	text = "Lives: " + str(Globals.lives)
