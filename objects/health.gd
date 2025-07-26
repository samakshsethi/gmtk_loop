extends CharacterBody2D


func _physics_process(delta: float) -> void:
	
	if move_and_slide():
		
		queue_free()
