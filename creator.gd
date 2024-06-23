extends Node3D

@onready var filename = $nonmoving/name.text
@onready var current = $Track

var car = preload("res://car.tscn")
var star = preload("res://star.tscn")
var jump = preload("res://jump.tscn")
var dash = preload("res://dash.tscn")
var dart = preload("res://dartpile.tscn")
var wind = preload("res://wind.tscn")
var bomb = preload("res://bomb.tscn")
var light = preload("res://light.tscn")

var straight = preload("res://tracks/straight.tscn")
var wide = preload("res://tracks/wide.tscn")
var rhard = preload("res://tracks/hard_r.tscn")
var lhard = preload("res://tracks/hard_l.tscn")
var srcurve = preload("res://tracks/srcurve.tscn")
var slcurve = preload("res://tracks/slcurve.tscn")
var lrcurve = preload("res://tracks/LRcurve.tscn")
var llcurve = preload("res://tracks/LLcurve.tscn")
var rsmall = preload("res://tracks/Rsmall.tscn")
var lsmall = preload("res://tracks/Lsmall.tscn")
var endtrack = preload("res://tracks/end.tscn")

var trackid = 18 # object's ID value

var cam2: String = "none"
var item: String = "none"
var mode: String = "track"
var shift: bool = false
var namefocus: bool = false #if the naming text edit is selected

var nodes: Array = [] #tracknodes
var objnodes: Array = [] #objectnodes

var objects: PackedStringArray = [] #objects data
var track: PackedStringArray = [] #tracks data
var rails: PackedStringArray = []




signal EXPORT

var map: PackedStringArray = ["Version: 1",
"IsBigEndian: True",
"SupportPaths: False",
"HasReferenceNodes: False",
"root:",
"  LayerInfos:",
"    - Infos:",
"        ObjInfo:",
"          - comment: !l -1",
"            dir_x: 0.00000",
"            dir_y: 90.00000",
"            dir_z: 0.00000",
"            id_name: obj0",
"            layer: LC",
"            link_info: []",
"            link_num: !l 0",
"            name: Fzr_PlayerStart",
"            param0: -1.00000",
"            param1: -1.00000",
"            param10: -1.00000",
"            param11: -1.00000",
"            param2: -1.00000",
"            param3: -1.00000",
"            param4: -1.00000",
"            param5: -1.00000",
"            param6: -1.00000",
"            param7: -1.00000",
"            param8: -1.00000",
"            param9: -1.00000",
"            pos_x: -4670.00000",
"            pos_y: 0.00000",
"            pos_z: 0.00000",
"            scale_x: 1.00000",
"            scale_y: 1.00000",
"            scale_z: 1.00000",
"          - comment: !l -1",
"            dir_x: 0.00000",
"            dir_y: 90.00000",
"            dir_z: 0.00000",
"            id_name: obj17",
"            layer: LC",
"            link_info: []",
"            link_num: !l 0",
"            name: Fzr_FieldParts01",
"            param0: -1.00000",
"            param1: -1.00000",
"            param10: -1.00000",
"            param11: -1.00000",
"            param2: -1.00000",
"            param3: -1.00000",
"            param4: -1.00000",
"            param5: -1.00000",
"            param6: -1.00000",
"            param7: -1.00000",
"            param8: -1.00000",
"            param9: -1.00000",
"            pos_x: 6400.00000",
"            pos_y: 0.00000",
"            pos_z: 0.00000",
"            scale_x: 1.00000",
"            scale_y: 1.00000",
"            scale_z: 1.00000",
"          - comment: !l -1",
"            dir_x: 0.00000",
"            dir_y: 270.00000",
"            dir_z: 0.00000",
"            id_name: obj2",
"            layer: LC",
"            link_info: []",
"            link_num: !l 0",
"            name: Fzr_Shutter",
"            param0: -1.00000",
"            param1: 1.00000",
"            param10: -1.00000",
"            param11: -1.00000",
"            param2: -1.00000",
"            param3: -1.00000",
"            param4: -1.00000",
"            param5: -1.00000",
"            param6: -1.00000",
"            param7: -1.00000",
"            param8: -1.00000",
"            param9: -1.00000",
"            pos_x: -4500.00000",
"            pos_y: 0.00000",
"            pos_z: 0.00000",
"            scale_x: 200.00000",
"            scale_y: 1.00000",
"            scale_z: 1.00000"]

var end: PackedStringArray = [
"      LayerName: LC",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L1",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L2",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L3",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L4",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L5",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L6",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L7",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L8",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L9",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L10",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L11",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L12",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L13",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L14",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L15",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L16",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L17",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L18",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L19",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L20",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L21",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L22",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L23",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L24",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L25"]


func _ready():
	Options.creator = self #stores reference to this node
	$nonmoving/name.placeholder_text = Options.defaultfilename
	if Options.autosave == true:
		$autosave.start(Options.autosavetime)
	#var endinst = endtrack.instantiate()
	#endinst.rotation_degrees.y = 90
	#endinst.position.x = 7100
	#add_child(endinst)
	#x = 6400 is where the track ends
	#addend()
	

var load = false
var cycle = 0

func loadfinished():
	highlighttrack(current)

func _physics_process(delta):
	if load == true:
		load = false
		loadfinished()
	if cam2 == "in":
		$Camera2.position = $Camera2.position.move_toward($Camera3D.position,10000 * delta)
	if cam2 == "out":
		if $Camera2.position != Vector3(2800,5100,3600):
			$Camera2.position = $Camera2.position.move_toward(Vector3(2800,5100,3600),10000 * delta)
		else:
			cam2 = "outfix"
	if cam2 == "outfix":
		$Camera2.position = $Camera2.position.move_toward(Vector3(2700,5000,3500),500 * delta)
	if mode == "track":
		var straightinst = null
		if item == "straight":
			straightinst = straight.instantiate()
		if item == "end":
			straightinst = endtrack.instantiate()
		if item == "endload":#no added track
			straightinst = endtrack.instantiate()
		if item == "wide":
			straightinst = wide.instantiate()
		if item == "Lsmall":
			straightinst = lsmall.instantiate()
		if item == "Rsmall":
			straightinst = rsmall.instantiate()
		if item == "llcurve":
			straightinst = llcurve.instantiate()
		if item == "lrcurve":
			straightinst = lrcurve.instantiate()
		if item == "slcurve":
			straightinst = slcurve.instantiate()
		if item == "srcurve":
			straightinst = srcurve.instantiate()
		if item == "rhard":
			straightinst = rhard.instantiate()
		if item == "lhard":
			straightinst = lhard.instantiate()
		if straightinst != null:
			randomize()
			$audio/clack.pitch_scale = randf_range(.8,1.3)
			$audio/clack/delay.start(.1)
			var offset = current.offset.global_position
			if item == "end":
				item = "straight"
			else:
				item = "none"
			connect("EXPORT", Callable(straightinst, "EXPORT"))
			$Track.add_child(straightinst)
			#if Input.is_action_pressed("backwards"):
				#offset.x -= current.offset.position.z*2
				#offset.z = -offset.z
				#straightinst.positionoffset.x = straightinst.positionoffset.x*9/14
				#straightinst.positionoffset.z = -straightinst.positionoffset.z
			straightinst.global_position = offset
			straightinst.applyoffset()
			nodes.append(straightinst)
			current = straightinst
			highlighttrack(current)
			trackid += 1
		
	var mouse_pos = get_viewport().get_mouse_position()
	var space_state = get_world_3d().direct_space_state
	var rayOrigin
	var rayEnd
	rayOrigin = $Camera3D.project_ray_origin(mouse_pos)
	rayEnd = rayOrigin + $Camera3D.project_ray_normal(mouse_pos) * 200000 #multiply for more range
	var parameters = PhysicsRayQueryParameters3D.create(rayOrigin,rayEnd)
	var intersection = space_state.intersect_ray(parameters)
	
	
	if shift == true:
		$Previews/wind/windBig.hide()
		$Previews/wind/windSmall.show()
		$Previews/dash/dashBig.hide()
		$Previews/dash/dashSmall.show()
		$CanvasLayer/Obstacles/wind.icon = preload("res://ui/objects/windsmall.png")
		$CanvasLayer/Obstacles/dash.icon = preload("res://ui/objects/dash.png")
	else:
		$Previews/wind/windBig.show()
		$Previews/wind/windSmall.hide()
		$Previews/dash/dashBig.show()
		$Previews/dash/dashSmall.hide()
		$CanvasLayer/Obstacles/wind.icon = preload("res://ui/objects/windbig.png")
		$CanvasLayer/Obstacles/dash.icon = preload("res://ui/objects/dash2.png")
	
	
	if not intersection.is_empty():
		if mode == "track":
			var track = intersection.collider.get_parent().get_parent()
			if Input.is_action_just_pressed("add"):
				highlighttrack(track)
				current = track
		
		if mode == "object":
			$Previews.show()
			var pos = intersection.position
			var inst = null
			if Input.is_action_just_pressed("add"):
				match item:
					"bomb":
						inst = bomb.instantiate()
					"wind":
						inst = wind.instantiate()
						if shift == true:
							inst.small = true
					"dash":
						inst = dash.instantiate()
						if shift == true:
							inst.small = true
					"dartpile":
						inst = dart.instantiate()
					"jump":
						inst = jump.instantiate()
					"star":
						inst = star.instantiate()
					"car":
						inst = car.instantiate()
					"light":
						inst = light.instantiate()
			if item != "none":
				get_node("Previews/" + item).position = pos -Vector3(0,pos.y,0)
			if inst != null:
				connect("EXPORT", Callable(inst, "EXPORT"))
				inst.position = pos -Vector3(0,pos.y,0)
				$Objects.add_child(inst)
				objnodes.append(inst)
				trackid += 1 
	else:
		$Previews.hide()
	get_input(delta)

func _notification(what): #if game quit
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if Options.saveonexit == true:
			save()
		get_tree().quit() # default behavior

func get_input(delta):
	if Input.is_action_just_pressed("enter"):
		$Camera3D.paused = false
		for node in get_tree().get_nodes_in_group("enter"):#any node that wants release focus when entered
			node.release_focus()
	if Input.is_action_just_pressed("Copy"):
		save()
		var path
		var fakeout = false
		if $nonmoving/name.text == "":
			$nonmoving/name.text = "untitled"
			fakeout = true
		path = Options.filepath + "/" + $nonmoving/name.text + ".txt"
		
		print(path)
		
		var file = FileAccess.open(path, FileAccess.READ)
		
		DisplayServer.clipboard_set(file.get_as_text())
		if fakeout == true:
			$nonmoving/name.text = ""
	if Input.is_action_just_pressed("export"):
		save()
		if $nonmoving/name.text == "":
			OS.shell_open(str("file://" + ProjectSettings.globalize_path(Options.filepath) + "/untitled" + ".txt"))
		else:
			OS.shell_open(str("file://" + ProjectSettings.globalize_path(Options.filepath) + "/" + $nonmoving/name.text + ".txt"))
	if Input.is_action_pressed("save"):
		$Camera3D.paused = true
		save()
	else:
		$Camera3D.paused = false
	if Input.is_action_just_pressed("shift"):
		shift = not shift
	if Input.is_action_just_pressed("esc"):
		if Options.saveonexit == true:
			save()
		get_tree().change_scene_to_file("res://title.tscn")
	if Input.is_action_just_pressed("Undo"):
		if nodes.size() != 0:
			if mode == "track":
				stored = nodes[nodes.size() - 1]
				nodes[nodes.size()-1].get_node("AnimationPlayer").play("undo")
				
				self.disconnect("EXPORT", Callable(nodes[nodes.size() - 1], "EXPORT"))
				nodes[nodes.size()-1].queue_free()
				nodes.remove_at(nodes.size() - 1)
				if nodes.size() != 0:
					current = nodes[nodes.size()-1]
				else:
					current = $Track
				highlighttrack(current)
				
		if objnodes.size() != 0:
			if mode != "track":
				objnodes[objnodes.size()-1].queue_free()
				objnodes.remove_at(objnodes.size() - 1)
				
				
			
	if Input.is_action_just_pressed("koolcam"):
		if $Camera3D.current == true:
			$cameraAnimation.play("whole track_IN")
		else:
			$cameraAnimation.play("whole track_OUT")
			
			
		
		

func highlighttrack(track):
	if track.get_node_or_null("RootNode/road") != null:
		for node in get_tree().get_nodes_in_group("track"):
			node.get_node("RootNode/road").material_overlay = null
		track.get_node("RootNode/road").material_overlay = load("res://track select.tres")

func save():
	if namefocus == false:
		var prename = $nonmoving/name.text
		if $nonmoving/name.text == "":
			$nonmoving/name.text = Options.defaultfilename
		filename = $nonmoving/name.text
		$nonmoving/saving.show()
		for node in $Track.get_children():
			if not node.is_in_group("ignore"):
				node.position.z += float($nonmoving/testoffset.text)
		emit_signal("EXPORT")
		
		var path = Options.filepath + "/" + $nonmoving/name.text + ".txt"
		var file = FileAccess.open(path,FileAccess.WRITE)
		var text = map + track + objects + rails + end
		if file.open(path, file.WRITE):
			file.open(path, file.WRITE)
			for content in text:
				file.store_line(content)
			file.close()
			$nonmoving/name.text = prename
		track = []
	
	
	var t = Timer.new()
	
	t.one_shot = true
	add_child(t)
	t.start(.1)
	await(t.timeout)
	$nonmoving/saving.hide()
	t.queue_free()

func _on_done_pressed():
	mode = "object"
	$uiAnimaiton.play("done->export")


func cam2in():
	cam2 = "in"


func cam2out():
	$Camera2.position = $Camera3D.position
	cam2 = "out"

var stored




func _on_back_pressed():
	for buttons in get_tree().get_nodes_in_group("button"):
		buttons.disabled = false
	mode = "track"
	$uiAnimaiton.play("done<-export")


func _on_delay_timeout():
	$audio/clack.play()


