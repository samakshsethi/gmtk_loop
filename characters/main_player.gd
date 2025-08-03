extends CharacterBody2D

signal death

# Preload the projectile scene so we can instantiate it later
@onready var projectile = load("res://objects/projectile.tscn")
@onready var dead_body_scene = preload("res://objects/dead_body.tscn") 
@onready var jump_sound = preload("res://music/sfx/Pop_1.wav")
@onready var laser_sound = preload("res://music/sfx/laser.wav")

# Player health system
var health = 100
var health_label: Label
var game_over_label: Label
var was_moving = true
# Movement constants - Updated with export variables for easy tweaking
@export_range(0.1, 2.0) var speed_multiplier = 1.2
@export_range(0.5, 2.0) var jump_multiplier = 1.8
@export_range(0.5, 2.0) var gravity_multiplier = 1.0
@export_range(0.0, 1.0) var friction = 0.2
@export_range(0.0, 1.0) var acceleration = 0.25

# Base values for calculations
const BASE_SPEED = 1000
const BASE_JUMP_SPEED = -1000
const BASE_GRAVITY = 4000

# Store initial spawn position
var spawn_position: Vector2
var allow_input = true

func _ready() -> void:
	spawn_position = global_position
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)
	
func _physics_process(delta: float) -> void:
			
	if allow_input: 
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
		# Then modify your jump code:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = BASE_JUMP_SPEED * jump_multiplier
		# Create an AudioStreamPlayer node
		var audio_player = AudioStreamPlayer.new()
		# Add it as a child of the current node
		add_child(audio_player)
		# Set the audio stream
		audio_player.stream = jump_sound
		# Play the sound
		audio_player.volume_db = -15
		audio_player.play()
		# Queue it for deletion after it's done playing
		audio_player.finished.connect(func(): audio_player.queue_free())
		
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
	if $AnimatedSprite2D.animation == "idle" or $AnimatedSprite2D.animation == "shot":
		$AnimatedSprite2D.play("looking_around")

var can_shoot = true  
		
func _input(event):
	# Handle shooting input
	if event.is_action_pressed("primary_shoot") and can_shoot:
		$AnimatedSprite2D.play("shot")
		var timer = get_tree().create_timer(0.15)
		timer.timeout.connect(shoot_towards_mouse)

func shoot_towards_mouse():
	if !can_shoot:
		return
		
	can_shoot = false
	
	# Play laser sound
	var audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = laser_sound
	audio_player.volume_db = -10  # Adjust volume as needed
	audio_player.play()
	audio_player.finished.connect(func(): audio_player.queue_free())
	
	# Get mouse position in world coordinates
	var mouse_pos = get_global_mouse_position()
	
	# Calculate direction from player to mouse
	var direction = (mouse_pos - global_position).normalized()
	var spawn_position = global_position + direction * 75
	
	# Create and fire a projectile
	var instance = projectile.instantiate()
	instance.dir = direction
	instance.spawnPosition = spawn_position
	instance.look_at(-direction)
	get_parent().add_child.call_deferred(instance)
	
	# Start cooldown timer
	var timer = get_tree().create_timer(1.2)
	timer.timeout.connect(func(): can_shoot = true)

func take_damage(amount: int):
	health -= amount
	# Check if player has died
	if health <= 0:
		death.emit()

func heal(amount: int):
	health += amount

func spawn_dead_body(death_position: Vector2):
	var dead_body = dead_body_scene.instantiate()
	
	# Set the dead body's position to current player position
	dead_body.position = death_position
	dead_body.collision_layer = 2      
	dead_body.collision_mask = 2  
	
	get_parent().add_child(dead_body)
	
func on_death():
	allow_input = false
	Globals.lives -= 1
	if Globals.lives == 0:
		game_over()

	hide()
	collision_layer = 512
	collision_mask = 512

	var death_position = global_position
	spawn_dead_body(death_position)
	global_position = spawn_position

	var respawn_timer = get_tree().create_timer(0.5)
	respawn_timer.timeout.connect(respawn)

func respawn():
	# Reset
	health = 100
	collision_layer = 3
	collision_mask = 3

	# Reset velocity
	velocity = Vector2.ZERO
	
	show()
	allow_input = true
	
func game_over():
	var lives_label: Label = get_node("../CanvasLayer/LivesLabel")
	var blink_timer: Timer = get_node("../CanvasLayer/GameOverLabel/BlinkTimer")
	var restart_button: Button = get_node("../CanvasLayer/StartButton")

	hide()
	process_mode = Node.PROCESS_MODE_DISABLED
	lives_label.visible = false
	blink_timer.start()
	restart_button.visible = true
