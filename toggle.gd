extends Button

func _ready():
	add_to_group("button")


func _on_straight_pressed():
	for buttons in get_tree().get_nodes_in_group("button"):
		buttons.disabled = false
	disabled = true
	
	
	get_parent().get_parent().get_parent().item = name



