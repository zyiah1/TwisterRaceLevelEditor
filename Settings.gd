extends Button

func _ready():
	if Options.firstopen and Options.filepath == "res://":
		$FileDialog.popup_centered()

func _on_pressed():
	get_tree().change_scene_to_file("res://settings.tscn")

func _notification(what): #if game quit
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit() # default behavior

func _on_file_dialog_dir_selected(dir):
	Options.filepath = dir
	Options.save()


func _on_file_dialog_canceled():
	$FileDialog.show()


func _on_file_dialog_file_selected(path):
	Options.firstopen = false
	Options.filepath = path
