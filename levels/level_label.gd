extends Label

func _ready():
	# Get parent name
	var root_name = get_parent().name
	# Set label text
	text = "Level " + str(int(root_name))
