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
			var inst = null
			var trackinst = null
			
			#if not content[8].begins_with("            name: "):
				#scene.load = true
				#print("whoops ",content[8])
				#return
			cycle = 27
			if content[8].begins_with("            name: Fzr_FieldParts"):
				var tracktype = int(content[8].lstrip("            name: Fzr_FieldParts"))
				match tracktype:
					1:
						trackinst = load("res://tracks/straight.tscn").instantiate()
					2:
						trackinst = load("res://tracks/wide.tscn").instantiate()
					3:
						trackinst = load("res://tracks/Lsmall.tscn").instantiate()
					4:
						trackinst = load("res://tracks/Rsmall.tscn").instantiate()
					5:
						trackinst = load("res://tracks/LLcurve.tscn").instantiate()
					6:
						trackinst = load("res://tracks/LRcurve.tscn").instantiate()
					7:
						trackinst = load("res://tracks/slcurve.tscn").instantiate()
					8:
						trackinst = load("res://tracks/srcurve.tscn").instantiate()
					13:
						trackinst = load("res://tracks/hard_l.tscn").instantiate()
					14:
						trackinst = load("res://tracks/hard_r.tscn").instantiate()
			
			
			if content[8].begins_with("            name: Fzr_GoalLine"):
				trackinst = load("res://tracks/end.tscn").instantiate()
			
			if content[8].begins_with("            name: Fzr_Bomb"):
				inst = preload("res://bomb.tscn").instantiate()
			if content[8].begins_with("            name: Fzr_Denchu"): #Fzr_DenchuSTL current import
				inst = preload("res://light.tscn").instantiate()
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
				# keep data:
				
			if trackinst != null:
				scene.connect("EXPORT", Callable(trackinst, "EXPORT"))
				scene.get_node("Track").add_child(trackinst)
				trackinst.global_position = Vector3(float(content[21].lstrip("            pos_x: ")),float(content[22].lstrip("            pos_y: ")),float(content[23].lstrip("            pos_z: ")))
				scene.nodes.append(trackinst)
				scene.current = trackinst
				trackinst.add_to_group("track")
				scene.highlighttrack(scene.current)
				# keep data:
				trackinst.TrackName = content[8].erase(0,22)
				trackinst.Param0 = float(content[9].erase(17).lstrip("            param: "))
				trackinst.Param1 = float(content[10].erase(17).lstrip("            param: "))
				trackinst.Param10 = float(content[11].erase(17,2).lstrip("            param: "))
				trackinst.Param11 = float(content[12].erase(17,2).lstrip("            param: "))
				trackinst.Param2 = float(content[13].erase(17).lstrip("            param: "))
				trackinst.Param3 = float(content[14].erase(17).lstrip("            param: "))
				trackinst.Param4 = float(content[15].erase(17).lstrip("            param: "))
				trackinst.Param5 = float(content[16].erase(17).lstrip("            param: "))
				trackinst.Param6 = float(content[17].erase(17).lstrip("            param: "))
				trackinst.Param7 = float(content[18].erase(17).lstrip("            param: "))
				trackinst.Param8 = float(content[19].erase(17).lstrip("            param: "))
				trackinst.Param9 = float(content[20].erase(17).lstrip("            param: "))
				if content[8].begins_with("            name: Fzr_GoalLine"):
					trackinst.ShutName = content[35].erase(0,22)
					trackinst.Param0Shut = float(content[36].erase(17).lstrip("            param: "))
					trackinst.Param1Shut = float(content[37].erase(17).lstrip("            param: "))
					trackinst.Param10Shut = float(content[38].erase(17,2).lstrip("            param: "))
					trackinst.Param11Shut = float(content[39].erase(17,2).lstrip("            param: "))
					trackinst.Param2Shut = float(content[40].erase(17).lstrip("            param: "))
					trackinst.Param3Shut = float(content[41].erase(17).lstrip("            param: "))
					trackinst.Param4Shut = float(content[42].erase(17).lstrip("            param: "))
					trackinst.Param5Shut = float(content[43].erase(17).lstrip("            param: "))
					trackinst.Param6Shut = float(content[44].erase(17).lstrip("            param: "))
					trackinst.Param7Shut = float(content[45].erase(17).lstrip("            param: "))
					trackinst.Param8Shut = float(content[46].erase(17).lstrip("            param: "))
					trackinst.Param9Shut = float(content[47].erase(17).lstrip("            param: "))
		if cycle < 0:
			print("ERR Not Recognized:" + content[0])
			content.remove_at(0)
		
		
	scene.load = true
	



func _on_file_dialog_file_selected(input):
	path = input
	start()
