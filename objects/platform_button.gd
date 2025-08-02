extends Area2D

var is_pressed = false
var bodies_on_button = 0  # Counter for bodies on the button
signal button_state_changed(is_pressed: bool)
@onready var platform = get_node("../disappearing_platform")

func _ready():
	# Connect signals for body entering and exiting
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	# Set initial texture
	$AnimatedSprite2D.play("unpressed")
	button_state_changed.connect(platform._on_button_state_changed)


func _on_body_entered(body):
	bodies_on_button += 1
	print("entered " + str(bodies_on_button))
	if bodies_on_button > 1 and !is_pressed:
		_press_button()

func _on_body_exited(body):
	bodies_on_button -= 1
	if bodies_on_button <= 1:
		_release_button()

func _press_button():
	is_pressed = true
	$AnimatedSprite2D.play("pressed")
	# You can emit a signal here if you want other objects to react
	button_state_changed.emit(true)

func _release_button():
	is_pressed = false
	$AnimatedSprite2D.play("unpressed")
	button_state_changed.emit(false)
