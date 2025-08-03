extends Area2D

# Reference to the plank that this button controls
var target_plank: Node2D = null
var is_pressed = false

func _ready():
	# Connect the body_entered signal to detect projectile hits
	body_entered.connect(_on_body_entered)
	
	# Try to find the plank in the scene
	find_plank()
	
	# Start with unpressed animation
	$AnimatedSprite2D.play("unpressed")

func _on_body_entered(body):
	# Check if the body that entered is a projectile
	if body.has_method("queue_free") and not is_pressed:  # Simple check for projectile
		print("Button hit by projectile!")
		trigger_pressed_animation()
		activate_plank_gravity()

func trigger_pressed_animation():
	# Play the pressed animation
	$AnimatedSprite2D.play("pressed")
	is_pressed = true
	print("Button pressed animation triggered!")

func find_plank():
	# Look for plank in the parent scene
	var parent = get_parent()
	if parent:
		target_plank = parent.get_node_or_null("plank")
		if target_plank:
			print("Button connected to plank")
		else:
			print("No plank found in scene")

func activate_plank_gravity():
	# Find the plank in the scene if not already found
	if target_plank == null:
		find_plank()
	
	if target_plank != null:
		print("Activating gravity on plank")
		# Enable gravity on the plank
		target_plank.enable_gravity()
	else:
		print("No plank found to activate gravity on")

# Function to set the target plank (can be called from level setup)
func set_target_plank(plank: Node2D):
	target_plank = plank
