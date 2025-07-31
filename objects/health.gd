extends CharacterBody2D



func _physics_process(delta: float) -> void:
	# Check for collisions with the health pickup
	if move_and_slide():
		# When something collides with the health pickup, destroy it
		# This prevents the pickup from being collected multiple times
		queue_free()
