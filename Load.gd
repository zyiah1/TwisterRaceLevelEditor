extends Button

var path = "res://test.txt"
var content = ""
var world = preload("res://world.tscn").instantiate()


func _on_pressed():
	$FileDialog.current_dir = Options.filepath
	$FileDialog.popup_centered()

func _process(delta):
	if Input.is_action_just_pressed("Paste"):
		content = str(DisplayServer.clipboard_get())
		LoadLevel("")

func _notification(what): #if game quit
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if get_parent().get_parent().get_node_or_null("Camera3D") == null:
			#we are creating a level currently
			return
		get_tree().quit() # default behavior

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
	
	
	get_parent().add_child(world)
	
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
			var track = false
			
			#if not content[8].begins_with("            name: "):
				#scene.load = true
				#print("whoops ",content[8])
				#return
			cycle = 27
			if content[8].begins_with("            name: Fzr_FieldParts"):
				var tracktype = int(content[8].lstrip("            name: Fzr_FieldParts"))
				track = true
				print(tracktype)
				match tracktype:
					1:
						inst = load("res://tracks/straight.tscn").instantiate()
					2:
						inst = load("res://tracks/wide.tscn").instantiate()
					3:
						inst = load("res://tracks/Lsmall.tscn").instantiate()
					4:
						inst = load("res://tracks/Rsmall.tscn").instantiate()
					5:
						inst = load("res://tracks/LLcurve.tscn").instantiate()
					6:
						inst = load("res://tracks/LRcurve.tscn").instantiate()
					7:
						inst = load("res://tracks/slcurve.tscn").instantiate()
					8:
						inst = load("res://tracks/srcurve.tscn").instantiate()
					13:
						inst = load("res://tracks/hard_l.tscn").instantiate()
					14:
						inst = load("res://tracks/hard_r.tscn").instantiate()
			
			
			if content[8].begins_with("            name: Fzr_GoalLine"):
				inst = load("res://tracks/end.tscn").instantiate()
			
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
			if content[8].begins_with("            name: Fzr_Bar"):
				inst = preload("res://bar.tscn").instantiate()
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
				if track: #track specific things
					scene.get_node("Track").add_child(inst)
					scene.nodes.append(inst)
					scene.current = inst
					inst.add_to_group("track")
					
				else: #object specific things
					scene.get_node("Objects").add_child(inst)
					scene.objnodes.append(inst)
				inst.global_position = Vector3(float(content[21].lstrip("            pos_x: ")),float(content[22].lstrip("            pos_y: ")),float(content[23].lstrip("            pos_z: ")))
				inst.global_rotation_degrees = Vector3(float(content[1].lstrip("            dir_x: ")),float(content[2].lstrip("            dir_y: ")),float(content[3].lstrip("            dir_z: ")))
				
				# keep data:
				
				
				
				
				# keep data:
				inst.DataName = content[8].erase(0,22)
				inst.Param0 = float(content[9].erase(17).lstrip("            param: "))
				inst.Param1 = float(content[10].erase(17).lstrip("            param: "))
				inst.Param10 = float(content[11].erase(17,2).lstrip("            param: "))
				inst.Param11 = float(content[12].erase(17,2).lstrip("            param: "))
				inst.Param2 = float(content[13].erase(17).lstrip("            param: "))
				inst.Param3 = float(content[14].erase(17).lstrip("            param: "))
				inst.Param4 = float(content[15].erase(17).lstrip("            param: "))
				inst.Param5 = float(content[16].erase(17).lstrip("            param: "))
				inst.Param6 = float(content[17].erase(17).lstrip("            param: "))
				inst.Param7 = float(content[18].erase(17).lstrip("            param: "))
				inst.Param8 = float(content[19].erase(17).lstrip("            param: "))
				inst.Param9 = float(content[20].erase(17).lstrip("            param: "))
				if content[8].begins_with("            name: Fzr_GoalLine"): #shutter data inject into the end goal
					inst.ShutName = content[35].erase(0,22)
					inst.Param0Shut = float(content[36].erase(17).lstrip("            param: "))
					inst.Param1Shut = float(content[37].erase(17).lstrip("            param: "))
					inst.Param10Shut = float(content[38].erase(17,2).lstrip("            param: "))
					inst.Param11Shut = float(content[39].erase(17,2).lstrip("            param: "))
					inst.Param2Shut = float(content[40].erase(17).lstrip("            param: "))
					inst.Param3Shut = float(content[41].erase(17).lstrip("            param: "))
					inst.Param4Shut = float(content[42].erase(17).lstrip("            param: "))
					inst.Param5Shut = float(content[43].erase(17).lstrip("            param: "))
					inst.Param6Shut = float(content[44].erase(17).lstrip("            param: "))
					inst.Param7Shut = float(content[45].erase(17).lstrip("            param: "))
					inst.Param8Shut = float(content[46].erase(17).lstrip("            param: "))
					inst.Param9Shut = float(content[47].erase(17).lstrip("            param: "))
		if cycle < 0:
			print("ERR Not Recognized:" + content[0])
			content.remove_at(0)
		
		
	scene.load = true
	



func _on_file_dialog_file_selected(input):
	path = input
	start()
