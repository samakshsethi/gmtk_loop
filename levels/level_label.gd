extends Label

func _ready():
	# Get root node name
	var root_name = get_parent().name
	# Set label text
	text = "Level " + str(int(root_name))
