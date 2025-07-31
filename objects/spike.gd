extends Area2D

func _ready():
	# Connect the body_entered signal to the handler
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print("Spike hit: ", body)
	# If the body has a take_damage method (e.g., the player), kill them
	if body.has_method("take_damage"):
		body.take_damage(100)  # Deal lethal damage
