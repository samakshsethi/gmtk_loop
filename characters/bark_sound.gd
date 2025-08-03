extends AudioStreamPlayer

func _ready():
	play()
	self.finished.connect(_on_Bark_finished)
	
func _on_Bark_finished():
	var enemy = get_parent()
	if not enemy.dead:
		await get_tree().create_timer(2.0).timeout
		play()
