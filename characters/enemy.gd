extends CharacterBody2D

# Preload the projectile scene for enemy attacks
@onready var projectile = load("res://objects/projectile.tscn")

# Enemy health system
var health = 100
var health_label: Label

func _ready() -> void:
	# Set up the health display when the enemy spawns
	setup_health_label()
	
	# Create a Timer node for regular shooting
	# This controls the turn-based combat timing
	var timer = Timer.new()
	add_child(timer)
	
	# Configure the timer for enemy attacks
	timer.wait_time = 5.0  # 5 seconds between shots
	timer.one_shot = false  # Makes it repeat indefinitely
	timer.timeout.connect(shoot)  # Connect the timeout signal to shoot function
	
	# Start the timer to begin the shooting cycle
	timer.start()
	
	# Fire the first shot immediately when enemy spawns
	shoot()


func setup_health_label():
	# Create a label to display the enemy's current health
	health_label = Label.new()
	add_child(health_label)
	health_label.position = Vector2(-20, -50)  # Position above the enemy character
	update_health_display()

func update_health_display():
	# Update the health label text to show current HP
	health_label.text = str(health) + " HP"
	
func take_damage(amount: int):
	# Handle damage taken by the enemy
	health -= amount
	update_health_display()  # Update the health display
	
func shoot():
	# Create and fire a projectile towards the player
	var instance = projectile.instantiate()
	instance.dir = Vector2(-1, 0)  # Direction Vector2(-1, 0) = left (towards player)
	instance.spawnPosition = global_position + Vector2(-50, 0)  # Spawn 50 pixels to the left
	get_parent().add_child.call_deferred(instance)  # Add to scene safely
