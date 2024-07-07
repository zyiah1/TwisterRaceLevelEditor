extends Button


func _pressed():
	get_parent().get_node("Panel").show()
