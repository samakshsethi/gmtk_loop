extends CharacterBody2D

# Reference to the main player character for healing interaction
@onready var main_character = get_parent().get_node("player")

# Movement constants
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	# Handle horizontal movement using standard Godot input
	# This allows the knight to move left and right
	# var direction := Input.get_axis("ui_left", "ui_right")
	# if direction:
	# 	velocity.x = direction * SPEED  # Move in the direction at full speed
	# else:
	# 	velocity.x = move_toward(velocity.x, 0, SPEED)  # Gradually slow down when no input

	# Check for collisions and handle healing interaction
	if move_and_slide():
		# When the knight collides with the main player, heal them
		main_character.heal(25)  # Restore 25 HP to the player
