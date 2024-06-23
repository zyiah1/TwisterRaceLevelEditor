extends Button

var settings = preload("res://Settings.gd")

func _on_pressed():
	get_tree().change_scene_to_file("res://Settings.tscn")

func _notification(what): #if game quit
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit() # default behavior

func _on_file_dialog_dir_selected(dir):
	Options.filepath = dir
	Options.save()


func _on_file_dialog_canceled():
	pass # Replace with function body.
