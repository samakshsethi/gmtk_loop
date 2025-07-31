extends Area2D


func _ready():
	# Connect the body_entered signal to the handler
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body):
	if body.name == "main_player":
		var current_scene = get_tree().current_scene.scene_file_path
		var next_level = current_scene.to_int() + 1
		
		var next_path = "res://levels/level_" + str(next_level) + ".tscn"
				
		get_tree().change_scene_to_file(next_path)
		
