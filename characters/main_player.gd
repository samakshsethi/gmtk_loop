extends CharacterBody2D

# Preload the projectile scene so we can instantiate it later
@onready var projectile = load("res://objects/projectile.tscn")

# Player health system
var health = 100
var health_label: Label
var game_over_label: Label

# Physics constants
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Movement constants
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	# Set up the health display when the player spawns
	setup_health_label()
	
	# Create initial delay timer before the player starts shooting
	# This gives the enemy a head start in the turn-based combat
	
	var initial_delay = Timer.new()
	add_child(initial_delay)
	initial_delay.wait_time = 2.0  # 2 seconds delay before first shot
	initial_delay.one_shot = true  # Only trigger once
	initial_delay.timeout.connect(start_shooting)  # Connect to shooting function
	initial_delay.start()

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

func setup_health_label():
	# Create a label to display the player's current health
	health_label = Label.new()
	add_child(health_label)
	health_label.position = Vector2(-20, -50)  # Position above the player character
	update_health_display()

func update_health_display():
	# Update the health label text to show current HP
	health_label.text = str(health) + " HP"
	
func start_shooting():
	# Create repeating timer for regular shots
	# This handles the turn-based shooting mechanic
	
	var shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.wait_time = 5.0  # 5 seconds between shots
	shoot_timer.one_shot = false  # Repeat indefinitely
	shoot_timer.timeout.connect(shoot)  # Connect to shoot function
	shoot_timer.start()
	
	# Fire the first shot immediately after the delay
	shoot()
	
	
func take_damage(amount: int):
	# Handle damage taken by the player
	health -= amount
	update_health_display()  # Update the health display
	
	# Check if player has died
	if health <= 0:
		game_over()

	
func heal(amount: int):
	# Handle healing received by the player
	health += amount
	update_health_display()  # Update the health display

func shoot():
	# Create and fire a projectile
	var instance = projectile.instantiate()
	instance.dir = 1  # Direction 1 = right (towards enemy)
	instance.spawnPosition = global_position + Vector2(50, 0)  # Spawn 50 pixels to the right
	get_parent().add_child.call_deferred(instance)  # Add to scene safely
	
	
	
func game_over():
	# Handle game over state
	# Show game over text
	game_over_label.show()
	
	# Pause the game to stop all activity
	get_tree().paused = true
	
	
func setup_game_over_label():
	# Create and configure the game over display
	game_over_label = Label.new()
	
	# Add to canvas layer to ensure it's always on top of everything
	var canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)
	canvas_layer.add_child(game_over_label)
	
	# Center the label on screen
	game_over_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	game_over_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Style the label with large red text
	game_over_label.add_theme_font_size_override("font_size", 64)
	game_over_label.modulate = Color(1, 0, 0)  # Red color
	
	# Position at center of screen
	game_over_label.set_anchors_preset(Control.PRESET_CENTER)
	
	# Hide initially and set text
	game_over_label.hide()
	game_over_label.text = "GAME OVER"
