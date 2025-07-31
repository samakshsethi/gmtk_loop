extends RigidBody2D

# Physics constants
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity_enabled = false

func _ready():
	# Start with gravity disabled
	gravity_scale = 0.0

func _physics_process(delta):
	# Only apply gravity if enabled
	if gravity_enabled:
		# Apply gravity manually since gravity_scale is 0
		gravity_scale = 1.0

func enable_gravity():
	# Enable gravity on the plank
	gravity_enabled = true
	gravity_scale = 1.0
	print("Plank gravity enabled!")

# Check if plank has landed on the floor
func _on_body_entered(body):
	if gravity_enabled and body is StaticBody2D:
		# Plank has hit the floor, disable gravity
		gravity_scale = 0.0
		gravity_enabled = false
		print("Plank landed on floor, gravity disabled")
