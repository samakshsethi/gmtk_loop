extends CharacterBody2D

@onready var projectile = load("res://objects/projectile.tscn")

var health = 100
var health_label: Label
var game_over_label: Label

func _ready() -> void:
	setup_health_label()
	
	# Create initial delay timer
	
	var initial_delay = Timer.new()
	add_child(initial_delay)
	initial_delay.wait_time = 2.0  # 2 seconds delay
	initial_delay.one_shot = true  # Only trigger once
	initial_delay.timeout.connect(start_shooting)
	initial_delay.start()

func setup_health_label():
	health_label = Label.new()
	add_child(health_label)
	health_label.position = Vector2(-20, -50)  # Position above the enemy
	update_health_display()

func update_health_display():
	health_label.text = str(health) + " HP"
	
func start_shooting():
	# Create repeating timer for shots
	var shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.wait_time = 5.0  # 5 seconds between shots
	shoot_timer.one_shot = false  # Repeat
	shoot_timer.timeout.connect(shoot)
	shoot_timer.start()
	
	# Initial shot after delay
	shoot()
	
	
func take_damage(amount: int):
	health -= amount
	update_health_display()
	if health <= 0:
		game_over()

	
func heal(amount: int):
	health += amount
	update_health_display()

func shoot():
	var instance = projectile.instantiate()
	instance.dir = 1
	instance.spawnPosition = global_position + Vector2(50, 0) 
	get_parent().add_child.call_deferred(instance)
	
	
	
func game_over():
	# Show game over text
	game_over_label.show()
	
	# Pause the game
	get_tree().paused = true
	
	
func setup_game_over_label():
	game_over_label = Label.new()
	# Add to canvas layer to ensure it's always on top
	var canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)
	canvas_layer.add_child(game_over_label)
	
	# Center the label
	game_over_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	game_over_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Style the label
	game_over_label.add_theme_font_size_override("font_size", 64)
	game_over_label.modulate = Color(1, 0, 0)  # Red color
	
	# Position at center of screen
	game_over_label.set_anchors_preset(Control.PRESET_CENTER)
	
	# Hide initially
	game_over_label.hide()
	game_over_label.text = "GAME OVER"
