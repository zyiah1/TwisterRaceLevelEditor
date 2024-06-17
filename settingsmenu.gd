extends Node2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	draw
	if Input.is_action_just_pressed("esc"):
		Options.save()
		get_tree().change_scene_to_file("res://title.tscn")


func _draw():
	draw_circle(Vector2(800,450),1700,Color.BLACK)

func _ready():
	if Options.trackfreecam == false:
		$freecam/off_on.icon = preload("res://ui/fonts/off.png")
	else:
		$freecam/off_on.icon = preload("res://ui/fonts/on.png")

func _on_freecam_pressed():
	$blip.play()
	$AnimationPlayer.play("freecam")
	Options.trackfreecam = not Options.trackfreecam
	if Options.trackfreecam == false:
		$freecam/off_on.icon = preload("res://ui/fonts/off.png")
	else:
		$freecam/off_on.icon = preload("res://ui/fonts/on.png")



func _on_file_dialog_dir_selected(dir):
	Options.filepath = dir
	Options.save()


func _on_filepath_pressed():
	$FileDialog.popup_centered()
