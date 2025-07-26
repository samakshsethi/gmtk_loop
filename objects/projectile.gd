extends CharacterBody2D

var speed = 200

var dir : int

var spawnPosition : Vector2


func _ready() -> void:
	global_position = spawnPosition
	

func _physics_process(delta: float) -> void:
	
	velocity = Vector2(dir * speed, 0)
	if move_and_slide():
		# Check all collisions
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			
			# Check if the collider has the take_damage method
			if collider.has_method("take_damage"):
				collider.take_damage(25)
		
		queue_free()
	
	
