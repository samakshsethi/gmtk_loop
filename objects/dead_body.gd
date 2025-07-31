extends CharacterBody2D

# Physics constants
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	# Apply gravity when not on the ground
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Apply movement
	move_and_slide()
