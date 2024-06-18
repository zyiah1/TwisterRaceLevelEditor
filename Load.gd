extends Button

var path = "res://test.txt"
var content = ""
var world = preload("res://world.tscn")


func _on_pressed():
	$FileDialog.current_dir = Options.filepath
	$FileDialog.popup_centered()

func _process(delta):
	if Input.is_action_just_pressed("Paste"):
		content = str(DisplayServer.clipboard_get())
		LoadLevel("")


func start():
	
	
	
	var file = FileAccess.open(path, FileAccess.READ)
	
	
	var name = str(path).get_file().left(str(path).get_file().length() - 1)
	name = name.left(name.length() - 1)
	name = name.left(name.length() - 1)
	name = name.left(name.length() - 1)
	content = file.get_as_text()
	
	file.close()
	
	content = str(content)
	
	print(name)
	
	LoadLevel(name)

func LoadLevel(name):
	for nodes in get_tree().get_nodes_in_group("delete"):
		nodes.queue_free()
	content = content.split("\n")
	var cycle = 89
	
	get_node("../New").hide()
	get_node("../Settings").hide()
	hide()
	
	
	get_parent().add_child(world.instantiate())
	
	var scene = get_parent().get_node("Creator")
	scene.get_node("Camera3D").current = true
	scene.get_node("nonmoving/name").text = name
	var nextid = 0
	var overide = 0
	if not content[0].begins_with("Version: 1"):
		print("invalid")
		return
	for line in content.size():
		overide = 0
		cycle -= 1
		if cycle + 1 > 0:
			content.remove_at(0)
		else:
			if content[8].begins_with("            name: Fzr_FieldParts"):
				cycle = 27
				var tracktype = content[8].lstrip("            name: Fzr_FieldParts")
				print(tracktype)
				match tracktype:
					"01":
						scene.itemqueue.append("straight")
					"02":
						scene.itemqueue.append("wide")
					"03":
						scene.itemqueue.append("Lsmall")
					"04":
						scene.itemqueue.append("Rsmall")
					"05":
						scene.itemqueue.append("llcurve")
					"06":
						scene.itemqueue.append("lrcurve")
					"07":
						scene.itemqueue.append("slcurve")
					"08":
						scene.itemqueue.append("srcurve")
					"13":
						scene.itemqueue.append("lhard")
					"14":
						scene.itemqueue.append("rhard")
			else:
				#if not content[8].begins_with("            name: "):
					#scene.load = true
					#print("whoops ",content[8])
					#return
				cycle = 27
				var inst = null
				
				if content[8].begins_with("            name: Fzr_GoalLine"):
					scene.itemqueue.append("end")
				
				if content[8].begins_with("            name: Fzr_Bomb"):
					inst = preload("res://bomb.tscn").instantiate()
				if content[8].begins_with("            name: Fzr_Jump"):
					inst = preload("res://jump.tscn").instantiate()
				if content[8].begins_with("            name: Fzr_Dart"):
					inst = preload("res://dartpile.tscn").instantiate()
				if content[8].begins_with("            name: Fzr_Dash2"):
					inst = preload("res://dash.tscn").instantiate()
				if content[8].begins_with("            name: Fzr_Star"):
					inst = preload("res://star.tscn").instantiate()
				if content[8].begins_with("            name: Fzr_Dash"):
					if not content[8].ends_with("2"):
						inst = preload("res://dash.tscn").instantiate()
						inst.small = true
				if content[8].begins_with("            name: Fzr_Wind"):
					inst = preload("res://wind.tscn").instantiate()
					var param1 = int(content[10].lstrip("            param1: "))
					if param1 == -1:
						inst.small = true
				if inst != null:
					scene.connect("EXPORT", Callable(inst, "EXPORT"))
					inst.position = Vector3(float(content[21].lstrip("            pos_x: ")),float(content[22].lstrip("            pos_y: ")),float(content[23].lstrip("            pos_z: ")))
					scene.get_node("Objects").add_child(inst)
					scene.objnodes.append(inst)
					
		if cycle < 0:
			print("ERR Not Recognized:" + content[0])
			content.remove_at(0)
		
		
	scene.load = true
	



func _on_file_dialog_file_selected(input):
	path = input
	start()
