extends Area2D

@onready var transition_animation = $transition_animation
@onready var timer = Timer.new()

func _ready():
	# Connect the body_entered signal to detect when the player enters
	body_entered.connect(_on_body_entered)
	
	# Add the timer to the scene and connect its timeout signal
	add_child(timer)
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func _on_body_entered(body):
	if body.name == "main_player":
		print("NextLevel: Player entered next_level area")
		# Play the slide-in animation
		transition_animation.get_node("AnimationPlayer").play("slide_in")
		# Start the timer for 0.6 seconds
		timer.start(0.6)

func _on_timer_timeout():
	# Change the scene after the timer finishes
	var current_scene = get_tree().current_scene.scene_file_path
	var level = current_scene.to_int()
	var next_level = level + 1 if level != null else 0
	var next_path = "res://levels/level_" + str(next_level) + ".tscn"
	print("NextLevel: Loading next level path: ", next_path)
	get_tree().change_scene_to_file(next_path)
		
