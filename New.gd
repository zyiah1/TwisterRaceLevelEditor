extends Button

var world = preload("res://world.tscn")

func _on_pressed():
	get_tree().change_scene_to_file("res://world.tscn")
