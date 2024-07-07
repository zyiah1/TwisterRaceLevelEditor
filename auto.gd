extends Button

var path: String
var content

signal movelevel(Pos)

func _pressed():
	$FileDialog.current_dir = Options.filepath
	$FileDialog.popup_centered()

func _on_file_dialog_file_selected(input):
	path = input
	var file = FileAccess.open(path, FileAccess.READ)
	content = file.get_as_text()
	file.close()
	content = str(content)
	content = content.split("\n")
	var GoalLine = content.find("            name: Fzr_GoalLine")
	if GoalLine == -1:
		return
		print("NO GOAL FOund")
	var goalpos = Vector3(float(content[GoalLine+13].lstrip("            pos_x: ")),float(content[GoalLine+14].lstrip("            pos_y: ")),float(content[GoalLine+15].lstrip("            pos_z: ")))
	print(goalpos)
	emit_signal("movelevel",goalpos)
