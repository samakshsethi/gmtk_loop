extends CharacterBody2D

# Preload the projectile scene for enemy attacks
@onready var projectile = load("res://objects/projectile.tscn")
@onready var player = get_node("../main_player")
# Enemy health system
var health = 100
var health_label: Label
var speed = 300
const BASE_GRAVITY = 4000
const GRAVITY = 980  # You can adjust this value
var player_alive = true

func _ready() -> void:
	# Set up the health display when the enemy spawns
	setup_health_label()
	add_to_group("enemies")
	


func _physics_process(delta: float) -> void:
	# Apply gravity
	handle_animation()
	velocity.y += GRAVITY * delta
	
	# Horizontal movement based on player position
	if !player_alive or player.position.x > position.x:
		velocity.x = speed  # Move right
		$AnimatedSprite2D.flip_h = false  # Face right
	else:
		velocity.x = -speed # Move left
		$AnimatedSprite2D.flip_h = true   # Face left
		
	move_and_slide()

func handle_animation():
	if !velocity.y and velocity.x < 10 and velocity.x > -10:
		$AnimatedSprite2D.play("default")
	else:
		$AnimatedSprite2D.play("run")


		
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
	if health <=0:
		$AnimatedSprite2D.play("dead")
		collision_layer = 512
	update_health_display()  # Update the health display


func _on_enemy_area_body_entered(body: Node2D) -> void:
	if body.name == "main_player":
		player_alive = false
		body.take_damage(100)
		# Create timer to set player_alive back to true
		var timer = get_tree().create_timer(1.0)
		timer.timeout.connect(func(): player_alive = true)
