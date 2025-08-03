extends AudioStreamPlayer

func _ready():
	play()
	self.finished.connect(_on_Bark_finished)
	
func _on_Bark_finished():
	var enemy = get_parent()
	if not enemy.dead:
		var random_time = [2.0, 4.0, 6.0].pick_random()
		await get_tree().create_timer(random_time).timeout
		play()
