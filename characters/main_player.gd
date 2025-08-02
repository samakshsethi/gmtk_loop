extends CharacterBody2D

# Preload the projectile scene so we can instantiate it later
@onready var projectile = load("res://objects/projectile.tscn")
@onready var dead_body_scene = preload("res://objects/dead_body.tscn") 

# Player health system
var health = 100
var health_label: Label
var game_over_label: Label
var was_moving = true
# Movement constants - Updated with export variables for easy tweaking
@export_range(0.1, 2.0) var speed_multiplier = 1.2
@export_range(0.5, 2.0) var jump_multiplier = 1.8
@export_range(0.5, 2.0) var gravity_multiplier = 1.0
@export_range(0.0, 1.0) var friction = 0.1
@export_range(0.0, 1.0) var acceleration = 0.25

# Base values for calculations
const BASE_SPEED = 1000
const BASE_JUMP_SPEED = -1000
const BASE_GRAVITY = 4000

# Store initial spawn position
var spawn_position: Vector2
var allow_input = true

func _ready() -> void:
	print(collision_layer)
	# Store initial spawn position
	spawn_position = global_position
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)
	# Set up the health display when the player spawns
	setup_health_label()
	
	
func _physics_process(delta: float) -> void:
			
	if allow_input: 
		update_health_display()
		handle_animation()
		
		# Apply gravity using multiplier
		velocity.y += BASE_GRAVITY * gravity_multiplier * delta
		
		# Handle horizontal movement with improved physics
		var dir = Input.get_axis("move_left", "move_right")
		if dir != 0:
			velocity.x = lerp(velocity.x, dir * BASE_SPEED * speed_multiplier, acceleration)
			$AnimatedSprite2D.flip_h = dir < 0
		else:
			velocity.x = lerp(velocity.x, 0.0, friction)
		
		# Handle jump input using multiplier
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = BASE_JUMP_SPEED * jump_multiplier
		
		# Apply movement
		move_and_slide()
	
func handle_animation():
	if !velocity.y and velocity.x < 10 and velocity.x > -10:
		if was_moving:
			$AnimatedSprite2D.play("idle")
			was_moving = false
			
	elif velocity.y:
		$AnimatedSprite2D.play("jump")
		was_moving = true
	elif velocity.x < 100 and velocity.x > -100:
		$AnimatedSprite2D.play("walk")
		was_moving = true
	else: 
		$AnimatedSprite2D.play("run")
		was_moving = true
		
func _on_animation_finished():
	if $AnimatedSprite2D.animation == "idle":
		$AnimatedSprite2D.play("looking_around")
		
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

func take_damage(amount: int):
	
	# Handle damage taken by the player
	health -= amount
	update_health_display()  # Update the health display
	
	# Check if player has died
	if health <= 0:
		print(collision_layer)
		var death_position = global_position
		global_position = spawn_position
		hide()
		allow_input = false
		collision_layer = 512
		collision_mask = 512
		spawn_dead_body(death_position)
	
		
		var respawn_timer = get_tree().create_timer(1.0)
		respawn_timer.timeout.connect(respawn)
		
		

func heal(amount: int):
	# Handle healing received by the player
	health += amount
	update_health_display()  # Update the health display

func spawn_dead_body(death_position: Vector2):
	# Create instance of dead body
	var dead_body = dead_body_scene.instantiate()
	
	# Set the dead body's position to current player position
	dead_body.position = death_position
	dead_body.collision_layer = 2      
	dead_body.collision_mask = 2  
	
	get_parent().add_child(dead_body)
	
func respawn():
	# Reset health
	health = 100
	collision_layer = 3
	collision_mask = 3
	update_health_display()
	# Reset position to spawn point
	
	print("spawning at " + str(spawn_position))
	# Reset velocity
	velocity = Vector2.ZERO
	
	show()
	allow_input = true

	
