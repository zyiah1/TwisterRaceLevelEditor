extends Node3D

var default_rotation = rotation_degrees

func _process(delta):
	if get_parent().get_parent().item == name:
		show()
	else:
		hide()
		position.y = -99999
		rotation_degrees = default_rotation
