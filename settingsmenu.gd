extends Node2D

@onready var oldtext = $settings/autosavetime/time.text

func _notification(what): #if game quit
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit() # default behavior

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	draw
	if Input.is_action_just_pressed("esc"):
		_on_back_pressed()
	if Input.is_action_just_pressed("enter"):
		for node in get_tree().get_nodes_in_group("hide"):
			node.release_focus()

func _draw():
	draw_circle(Vector2(800,450),1700,Color.BLACK)
	

func _ready():
	if Options.trackfreecam == false:
		$settings/freecam.text = "freecam off"
	else:
		$settings/freecam.text = "freecam on"
	if Options.saveonexit == false:
		$settings/saveonexit.text = "save when exit off"
	else:
		$settings/saveonexit.text = "save when exit on"
	if Options.autosave == false:
		$settings/autosave.text = "autosave off"
	else:
		$settings/autosave.text = "autosave on"
	$settings/defaultname/name.text = Options.defaultfilename
	$settings/autosavetime/time.text = str(Options.autosavetime)
	oldtext = $settings/autosavetime/time.text

func _on_freecam_pressed():
	Options.trackfreecam = not Options.trackfreecam
	_ready() #refresh the text

func _on_saveonexit_pressed():
	Options.saveonexit = not Options.saveonexit
	_ready() #refresh the text


func _on_autosave_pressed():
	Options.autosave = not Options.autosave
	_ready() #refresh the text

func _on_file_dialog_dir_selected(dir):
	Options.filepath = dir
	Options.save()


func _on_filepath_pressed():
	$FileDialog.popup_centered()


func _on_back_pressed():
	Options.save()
	get_tree().change_scene_to_file("res://title.tscn")





func _on_name_text_changed(newtext):
	Options.defaultfilename = newtext


func _on_time_text_changed(newtext):
	if not newtext.is_valid_int() or int(newtext) != abs(int(newtext)):
		$settings/autosavetime/time.text = oldtext
		$settings/autosavetime/time.caret_column = 999
		return
	oldtext = newtext
	Options.autosavetime = int(newtext)
