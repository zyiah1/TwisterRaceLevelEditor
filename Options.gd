extends Node


var filepath = "res://"
var trackfreecam = true
var creator
var data = [filepath,str(trackfreecam)]
var firstopen = true

func _ready():
	print("hello world")
	var file = FileAccess.file_exists("res://Fzero.settings")
	if file:
		firstopen = false
		print("Found Settings File!")
		file = FileAccess.open("res://Fzero.settings",FileAccess.READ)
		var content = file.get_as_text().split("\n")
		filepath = content[0]
		if content[1] == "true":
			trackfreecam = true
		else:
			trackfreecam = false
	else:
		file = FileAccess.open("res://Fzero.settings",FileAccess.WRITE)
		print("Creating New Settings File...")
		if file.open(Options.filepath + "test" + ".txt", file.WRITE):
			file.open(Options.filepath + "test" + ".txt", file.WRITE)
			for line in data:
				file.store_line(line)
			file.close()


func save():
	print(filepath)
	data = [filepath,str(trackfreecam)]
	var file = FileAccess.open("res://Fzero.settings",FileAccess.WRITE)
	print("Saving")
	if file:
		file
		for line in data:
			file.store_line(line)
		file.close()
