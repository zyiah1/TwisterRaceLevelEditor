extends Button


func _pressed():
	$AnimationPlayer.play("select")
	$blip.play()
