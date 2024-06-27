extends Button

var path = "res://test.txt"
var content = ""
var world = preload("res://world.tscn").instantiate()


func _on_pressed():
	$FileDialog.current_dir = Options.filepath
	$FileDialog.popup_centered()

func _process(delta):
	if DisplayServer.clipboard_get().begins_with("Version: 1"):
		$Paste.show()
	else:
		$Paste.hide()
	if Input.is_action_just_pressed("Paste"):
		if visible: #dont load level twice
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
	var cycle = 8
	
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
	while content.size() > 10:
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
			if content[8].begins_with("            name: Fzr_Shutter") or content[8].begins_with("            name: Fzr_NormalShutter"):
				#set the start object position
				scene.startposition = Vector3(float(content[21].lstrip("            pos_x: ")),float(content[22].lstrip("            pos_y: ")),float(content[23].lstrip("            pos_z: "))) - Vector3(170,0,0)
				scene.startrotation = Vector3(float(content[1].lstrip("            dir_x: ")),float(content[2].lstrip("            dir_y: ")),float(content[3].lstrip("            dir_z: "))) - Vector3(0,180,0)
				print("hey")
			
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
				inst = preload("res://objects/bomb.tscn").instantiate()
			if content[8].begins_with("            name: Fzr_Denchu"): #Fzr_DenchuSTL current import
				inst = preload("res://objects/light.tscn").instantiate()
			if content[8].begins_with("            name: Fzr_Jump"):
				inst = preload("res://objects/jump.tscn").instantiate()
			if content[8].begins_with("            name: Fzr_Dart"):
				inst = preload("res://objects/dartpile.tscn").instantiate()
			if content[8].begins_with("            name: Fzr_Dash2"):
				inst = preload("res://objects/dash.tscn").instantiate()
			if content[8].begins_with("            name: Fzr_Star"):
				inst = preload("res://objects/star.tscn").instantiate()
			if content[8].begins_with("            name: Fzr_Bar"):
				inst = preload("res://objects/bar.tscn").instantiate()
			if content[8].begins_with("            name: Fzr_Obstacle"):
				inst = preload("res://objects/obstacle.tscn").instantiate()
			if content[8].begins_with("            name: Fzr_ObstThro"):
				inst = preload("res://objects/obstaclethro.tscn").instantiate()
			if content[8].begins_with("            name: Fzr_EnemyCarBattery"):
				inst = preload("res://objects/battery.tscn").instantiate()
			if content[8].begins_with("            name: Fzr_EnemyCar"):
				if float(content[13].erase(17).lstrip("            param: ")) == 7:
					inst = preload("res://objects/shortbrokencar.tscn").instantiate()
				#else:
					
			if content[8].begins_with("            name: Fzr_EnemyTrailer"): #long car
				if float(content[13].erase(17).lstrip("            param: ")) == 7:
					inst = preload("res://objects/longbrokencar.tscn").instantiate()
				#else:
					
			if content[8].begins_with("            name: Fzr_Stop"): #long car
				inst = preload("res://objects/borderbarsmall.tscn").instantiate()
			if content[8].begins_with("            name: Fzr_Stop2"): #long car
				inst = preload("res://objects/borderbar.tscn").instantiate()
			if content[8].begins_with("            name: Fzr_Dash"):
				if not content[8].begins_with("            name: Fzr_Dash2"):
					inst = preload("res://objects/dash.tscn").instantiate()
					inst.small = true
			if content[8].begins_with("            name: Fzr_Wind"):
				inst = preload("res://objects/wind.tscn").instantiate()
				var param1 = int(content[10].lstrip("            param1: "))
				if param1 == -1:
					inst.small = true
			if inst != null:
				cycle = 27
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
		if cycle < 0:
			print("ERR Not Recognized:" + content[0])
			content.remove_at(0)
		
		
	scene.load = true
	



func _on_file_dialog_file_selected(input):
	path = input
	start()


func _on_paste_pressed():
	if visible:
		content = str(DisplayServer.clipboard_get())
		LoadLevel("")
