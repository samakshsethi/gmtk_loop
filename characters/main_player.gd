extends CharacterBody2D

# Preload the projectile scene so we can instantiate it later
@onready var projectile = load("res://objects/projectile.tscn")
@onready var dead_body_scene = preload("res://objects/dead_body.tscn") 
# Player health system
var health = 100
var health_label: Label
var game_over_label: Label

# Physics constants
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Movement constants
var spawn_position: Vector2
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	
	# Store initial spawn position
	spawn_position = global_position
	
	# Set up the health display when the player spawns
	setup_health_label()
	
	# Create initial delay timer before the player starts shooting
	# This gives the enemy a head start in the turn-based combat
	# COMMENTED OUT - Now using mouse-aimed shooting instead
	# var initial_delay = Timer.new()
	# add_child(initial_delay)
	# initial_delay.wait_time = 2.0  # 2 seconds delay before first shot
	# initial_delay.one_shot = true  # Only trigger once
	# initial_delay.timeout.connect(start_shooting)  # Connect to shooting function
	# initial_delay.start()

func _physics_process(delta: float) -> void:
	# Apply gravity when not on the ground
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump input
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle horizontal movement using custom input map
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED  # Move in the direction at full speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)  # Gradually slow down when no input
	
	# Apply movement
	move_and_slide()

func _input(event):
	# Handle shooting input
	if event.is_action_pressed("primary_shoot"):
		shoot_towards_mouse()

func shoot_towards_mouse():
	# Get mouse position in world coordinates
	var mouse_pos = get_global_mouse_position()
	
	# Calculate direction from player to mouse
	var direction = (mouse_pos - global_position).normalized()
	
	# Create and fire a projectile
	var instance = projectile.instantiate()
	instance.dir = direction  # Pass the full direction vector
	instance.spawnPosition = global_position + direction * 50  # Spawn 50 pixels in direction
	get_parent().add_child.call_deferred(instance)

func setup_health_label():
	# Create a label to display the player's current health
	health_label = Label.new()
	add_child(health_label)
	health_label.position = Vector2(-20, -50)  # Position above the player character
	update_health_display()

func update_health_display():
	# Update the health label text to show current HP
	health_label.text = str(health) + " HP"
	
# COMMENTED OUT - Old automated shooting system
# func start_shooting():
# 	# Create repeating timer for regular shots
# 	# This handles the turn-based shooting mechanic
# 	
# 	var shoot_timer = Timer.new()
# 	add_child(shoot_timer)
#  shoot_timer.wait_time = 5.0  # 5 seconds between shots
# 	shoot_timer.one_shot = false  # Repeat indefinitely
# 	shoot_timer.timeout.connect(shoot)  # Connect to shoot function
# 	shoot_timer.start()
# 	
# 	# Fire the first shot immediately after the delay
# 	shoot()
	
	
func take_damage(amount: int):
	# Handle damage taken by the player
	health -= amount
	update_health_display()  # Update the health display
	
	# Check if player has died
	if health <= 0:
		spawn_dead_body()
		respawn()

	
func heal(amount: int):
	# Handle healing received by the player
	health += amount
	update_health_display()  # Update the health display

# COMMENTED OUT - Old horizontal shooting function
# func shoot():
# 	# Create and fire a projectile
# 	var instance = projectile.instantiate()
# 	instance.dir = 1  # Direction 1 = right (towards enemy)
# 	instance.spawnPosition = global_position + Vector2(50, 0)  # Spawn 50 pixels to the right
# 	get_parent().add_child.call_deferred(instance)  # Add to scene safely
	

func spawn_dead_body():
	# Create instance of dead body
	var dead_body = dead_body_scene.instantiate()
	
	# Set the dead body's position to current player position
	dead_body.global_position = global_position
	
	print("spawning dead body")
	# Add dead body to the scene
	get_parent().add_child(dead_body)
	
func respawn():
	print("lol")
	# Reset health
	health = 100
	update_health_display()
	
	# Reset position to spawn point
	global_position = spawn_position
	
	# Reset velocity
	velocity = Vector2.ZERO
	
	
