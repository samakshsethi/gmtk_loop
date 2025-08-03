extends CharacterBody2D

# Preload the projectile scene for enemy attacks
@onready var projectile = load("res://objects/projectile.tscn")
@onready var player = get_node("../main_player")
# Enemy health system
var health = 300
var health_label: Label
var speed = 300
const BASE_GRAVITY = 4000
const GRAVITY = 980
var player_alive = true
var dead = false

func _ready() -> void:
	$BarkSound.play()
	add_to_group("enemies")

func _physics_process(delta: float) -> void:
	# Apply gravity
	velocity.y += GRAVITY * delta
	
	if !dead:
		handle_animation()
		
		# Horizontal movement based on player position
		if get_node_or_null("dont_move") != null:
			velocity.x = 0
		elif !player_alive or player.position.x > position.x:
			velocity.x = speed
			$AnimatedSprite2D.flip_h = false
		else:
			velocity.x = -speed
			$AnimatedSprite2D.flip_h = true
		
		move_and_slide()

func handle_animation():
	if $AnimatedSprite2D.animation == "damage" and $AnimatedSprite2D.is_playing():
		return
		
	if !velocity.x:
		$AnimatedSprite2D.play("default")
	elif velocity.x :
		$AnimatedSprite2D.play("run")
	
func take_damage(amount: int):
	# Handle damage taken by the enemy
	health -= amount
	$AnimatedSprite2D.play("damage")
	if health <= 0:
		dead = true
		$AnimatedSprite2D.play("dead")
		$BarkSound.stop()
		collision_layer = 512
		collision_mask = 512
		$enemy_area.collision_layer = 512
		$enemy_area.collision_mask = 512

func _on_enemy_area_body_entered(body: Node2D) -> void:
	if body.name == "main_player":
		player_alive = false
		body.take_damage(100)
		# Create timer to set player_alive back to true
		var timer = get_tree().create_timer(1.0)
		timer.timeout.connect(func(): player_alive = true)
