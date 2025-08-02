extends CharacterBody2D

# Preload the projectile scene for enemy attacks
@onready var projectile = load("res://objects/projectile.tscn")

# Enemy health system
var health = 100
var health_label: Label

func _ready() -> void:
	# Set up the health display when the enemy spawns
	setup_health_label()
	



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
