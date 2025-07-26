extends CharacterBody2D

@onready var projectile = load("res://objects/projectile.tscn")


var health = 100
var health_label: Label

func _ready() -> void:
	setup_health_label()
	
	# Create a Timer node
	var timer = Timer.new()
	add_child(timer)
	
	# Configure the timer
	timer.wait_time = 5.0  # 5 seconds
	timer.one_shot = false  # Makes it repeat
	timer.timeout.connect(shoot)  # Connect the timeout signal to shoot function
	
	# Start the timer
	timer.start()
	
	# Initial shot
	shoot()


func setup_health_label():
	health_label = Label.new()
	add_child(health_label)
	health_label.position = Vector2(-20, -50)  # Position above the enemy
	update_health_display()

func update_health_display():
	health_label.text = str(health) + " HP"
	
func take_damage(amount: int):
	health -= amount
	update_health_display()
	
func shoot():
	var instance = projectile.instantiate()
	instance.dir = -1
	instance.spawnPosition = global_position + Vector2(-50, 0) 
	get_parent().add_child.call_deferred(instance)
