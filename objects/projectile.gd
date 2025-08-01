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
			
			# Check if the object we hit has a take_damage method
			# This allows projectiles to damage both player and enemy
			if collider.has_method("take_damage"):
				collider.take_damage(25)  # Deal 25 damage to the target
		
		# Destroy the projectile after hitting something
		queue_free()
	
	
