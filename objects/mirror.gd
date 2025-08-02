extends Area2D

func _ready():
	# Connect the body_entered signal to detect projectile hits
	body_entered.connect(_on_body_entered)
	
	
func _is_reflective():
	return true

func _on_body_entered(body):
	if body.has_method("reflect"):
		body.reflect(global_rotation)
		
