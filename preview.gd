extends Node3D


func _process(delta):
	if get_parent().get_parent().item == name:
		show()
	else:
		hide()
		position.y = -99999
