extends StaticBody2D  # or any other node type you're using for the platform

func _ready():

	disappear()

func appear():
	show()
	collision_layer = 3

func disappear():

	hide()
	collision_layer = 512

# Function to be connected to the button's signal
func _on_button_state_changed(button_pressed: bool):
	if button_pressed:
		appear()
	else:
		disappear()
