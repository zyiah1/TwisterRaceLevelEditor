extends Node

#settings
var filepath: String = "res://"
var trackfreecam: bool = true
var saveonexit: bool = false
var autosave: bool = true
var autosavetime: int = 20
var defaultfilename: String = "untitled"
var firstboot = true #for update checker

var creator
var data = [filepath,str(trackfreecam),str(saveonexit),str(autosave),str(autosavetime),defaultfilename,str(firstboot)]
var firstopen = true



func _process(delta):
	if Input.is_action_just_pressed("open folder"):
		OS.shell_open(str("file://" + ProjectSettings.globalize_path(Options.filepath)))

func _ready():
	get_tree().set_auto_accept_quit(false)
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
		if content.size()-1 < data.size(): #the -1 is for the extra blank line at the end of the save file
			print("oldfile,less settings, adding data")#need to upgrade old save files
			save()
		else:
			if content[2] == "true":
				saveonexit = true
			else:
				saveonexit = false
			if content[3] == "true":
				autosave = true
			else:
				autosave = false
			autosavetime = int(content[4])
			defaultfilename = content[5]
			if content[6] == "true":
				firstboot = true
			else:
				firstboot = false
	else:
		file = FileAccess.open("res://Fzero.settings",FileAccess.WRITE)
		print("Creating New Settings File...")
		if file.open(Options.filepath + "test" + ".txt", file.WRITE):
			file.open(Options.filepath + "test" + ".txt", file.WRITE)
			for line in data:
				file.store_line(line)
			file.close()


func save():
	data = [filepath,str(trackfreecam),str(saveonexit),str(autosave),str(autosavetime),defaultfilename,str(firstboot)]
	var file = FileAccess.open("res://Fzero.settings",FileAccess.WRITE)
	print("Saving")
	if file:
		file
		for line in data:
			file.store_line(line)
		file.close()
