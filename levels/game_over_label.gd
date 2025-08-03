extends Label

func _ready():
	$BlinkTimer.connect("timeout", _on_blink_timer_timeout)

func _on_blink_timer_timeout():
	visible = not visible

func _on_start_button_pressed() -> void:
	Globals.lives = 8
	get_tree().change_scene_to_file("res://game.tscn")
