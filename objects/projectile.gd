extends CharacterBody2D

# Movement speed of the projectile
var speed = 1000

# Direction the projectile travels (Vector2 for 2D movement)
var dir : Vector2

# Starting position where the projectile spawns
var spawnPosition : Vector2

func _ready() -> void:
	# Set the projectile's initial position when it spawns
	global_position = spawnPosition

func _physics_process(delta: float) -> void:
	# Move the projectile in the specified direction
	velocity = dir * speed
	
	# Check for collisions while moving
	if move_and_slide():
		# If we hit something, check all collision points
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			
			if collider.has_method("_is_reflective"):
				print("mirror touched")
	
				var normal = collision.get_normal()
				# Calculate the reflection direction
				dir = dir.bounce(normal)
				# Don't destroy the projectile, let it continue with new direction
				return
			# Check if the object we hit has a take_damage method  # Deal 25 damage to the target
		
		# Destroy the projectile after hitting something
		var timer = get_tree().create_timer(0.02)
		timer.timeout.connect(func(): queue_free())
	
	
func reflect(mirror_rotation: float) -> void:
	# Convert the mirror's rotation to a normal vector
	var mirror_normal = Vector2.RIGHT.rotated(mirror_rotation)
	
	# Calculate the reflection
	dir = dir.reflect(mirror_normal)
	look_at(dir + position)
	rotate(PI)
	# Optionally, you might want to add a small offset to prevent multiple reflections
	position += dir * 10


func _on_area_2d_body_entered(body: Node2D) -> void:
	var damage = 100
	if body.has_method("take_damage"):
		if body.name == "enemy":
			damage = 40
		body.take_damage(damage) # Replace with function body.
