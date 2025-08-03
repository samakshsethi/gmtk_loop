extends Node2D

@onready var transition_animation = $transition_animation

func _ready():
	# Play the slide-out animation when the level loads
	transition_animation.get_node("AnimationPlayer").play("slide_out")
