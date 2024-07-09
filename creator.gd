extends Node3D

@onready var filename = $nonmoving/name.text
@onready var current = $Track

@onready var PropertyDataContainer = $"nonmoving/Properties/TabContainer/Raw Data/Data/VBoxContainer"

var car = preload("res://objects/car.tscn")
var star = preload("res://objects/star.tscn")
var jump = preload("res://objects/jump.tscn")
var dash = preload("res://objects/dash.tscn")
var dart = preload("res://objects/dartpile.tscn")
var bomb = preload("res://objects/bomb.tscn")
var light = preload("res://objects/light.tscn")

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

var trackid = 0 # object's ID value

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

var redotrack = []
var redoobj = []

var editednode = null

signal EXPORT

var map: PackedStringArray = ["Version: 1",
"IsBigEndian: True",
"SupportPaths: False",
"HasReferenceNodes: False",
"root:",
"  LayerInfos:",
"    - Infos:",
"        ObjInfo:"]

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

var startposition = Vector3(-4670,0,0)
var startrotation = Vector3(0,90,0)
var startinst = load("res://tracks/start.tscn").instantiate()

func _ready():
	Options.creator = self #stores reference to this node
	for node in get_tree().get_nodes_in_group("startoffset"):
		node.connect("pressed",Callable(self,"offset_button_pressed").bind(node.startoffset))
	$nonmoving/name.placeholder_text = Options.defaultfilename
	if get_tree().current_scene.name == "Creator": #to see if we are loading
		startinst.position = startposition
		startinst.rotation_degrees = startrotation
		add_child(startinst)
		connect("EXPORT", Callable(startinst, "EXPORT"))
		connect("EXPORT", Callable(startinst.get_node("shutter"), "EXPORT"))
		if Options.autosave == true:
			$autosave.start(Options.autosavetime)

var load = false
var cycle = 0
var backwards: bool = false

func loadfinished():
	highlighttrack(current)
	startinst.position = startposition
	$Track/offset.position.z = startposition.x + 4675
	startinst.rotation_degrees = startrotation
	add_child(startinst)
	connect("EXPORT", Callable(startinst, "EXPORT"))
	connect("EXPORT", Callable(startinst.get_node("shutter"), "EXPORT"))
	if Options.autosave == true:
		$autosave.start(Options.autosavetime)
	$Camera3D.position = startinst.global_position
	$Camera3D.position.y = 500

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
		if item == "shutter":
			straightinst = load("res://tracks/shutter.tscn").instantiate()
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
			redotrack = []
			$audio/clack.pitch_scale = randf_range(.8,1.3)
			$audio/clack/delay.start(.1)
			var offset = current.offset.global_position
			if item == "end":
				item = "straight"
			else:
				item = "none"
			connect("EXPORT", Callable(straightinst, "EXPORT"))
			$Track.add_child(straightinst)
			var oldoffset = straightinst.positionoffset
			if backwards:
				offset.x -= 1400
				straightinst.positionoffset = -current.positionoffset #set position
			straightinst.global_position = offset
			straightinst.applyoffset()
			straightinst.positionoffset = oldoffset #keep so next track works
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
	
	
	
	$Previews/stop/stoplong.visible = shift
	$Previews/stop/stopshort.visible = not shift
	$Previews/wind/windBig.visible = not shift
	$Previews/dash/dashBig.visible = not shift
	$Previews/obstacle/normal.visible = not shift
	$Previews/bar/down.visible = not shift
	$Previews/wind/windSmall.visible = shift
	$Previews/dash/dashSmall.visible = shift
	$Previews/obstacle/thro.visible = shift
	$Previews/bar/up.visible = shift
	
	if shift == true:
		$CanvasLayer/Obstacles/wind.icon = preload("res://ui/objects/windsmall.png")
		$CanvasLayer/Obstacles/dash.icon = preload("res://ui/objects/dash.png")
		$CanvasLayer/Obstacles/obstacle.icon = preload("res://ui/objects/obstaclethro.png")
		$CanvasLayer/Obstacles/stop.icon = preload("res://ui/objects/stoplong.png")
		$CanvasLayer/Obstacles/bar.icon = preload("res://ui/objects/barup.png")
	else:
		$CanvasLayer/Obstacles/wind.icon = preload("res://ui/objects/windbig.png")
		$CanvasLayer/Obstacles/dash.icon = preload("res://ui/objects/dash2.png")
		$CanvasLayer/Obstacles/obstacle.icon = preload("res://ui/objects/obstacle.png")
		$CanvasLayer/Obstacles/stop.icon = preload("res://ui/objects/stopshort.png")
		$CanvasLayer/Obstacles/bar.icon = preload("res://ui/objects/bar.png")
	
	if not intersection.is_empty():
		if mode == "track":
			var track = intersection.collider.get_parent().get_parent()
			if Input.is_action_just_pressed("add"):
				highlighttrack(track)
				current = track
		
		if Input.is_action_just_pressed("unrotate"):
			rotate_counterclockwise()
		elif Input.is_action_just_pressed("rotate"):
			rotate_clockwise()
		
		
		if mode == "object":
			$Previews.show()
			var pos = intersection.position
			var inst = null
			if Input.is_action_just_pressed("add"):
				match item:
					"bomb":
						inst = bomb.instantiate()
					"wind":
						inst = load("res://objects/windbig.tscn").instantiate()
						if shift == true:
							inst = load("res://objects/windsmall.tscn").instantiate()
					"dash":
						inst = load("res://objects/dash2.tscn").instantiate()
						if shift == true:
							inst = dash.instantiate()
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
					"bar":
						inst = load("res://objects/bardown.tscn").instantiate()
						if shift:
							inst = load("res://objects/barup.tscn").instantiate()
					"battery":
						inst = load("res://objects/battery.tscn").instantiate()
					"obstacle":
						inst = load("res://objects/obstacle.tscn").instantiate()
						if shift:
							inst = load("res://objects/obstaclethro.tscn").instantiate()
					"shortcarbroke":
						inst = load("res://objects/shortbrokencar.tscn").instantiate()
					"longcarbroke":
						inst = load("res://objects/longbrokencar.tscn").instantiate()
					"stop":
						inst = load("res://objects/borderbarsmall.tscn").instantiate()
						if shift:
							inst = load("res://objects/borderbar.tscn").instantiate()
			if item != "none":
				if Input.is_action_pressed("yrotate"):
					if get_node("Previews/" + item).position != pos -Vector3(0,pos.y,0):
						get_node("Previews/" + item).look_at(pos -Vector3(0,pos.y,0))
						get_node("Previews/" + item).rotation.x = 0
						get_node("Previews/" + item).rotation.z = 0
				else:
					get_node("Previews/" + item).position = pos -Vector3(0,pos.y,0) #y pos = 0
			
			if inst != null:
				redoobj = []
				connect("EXPORT", Callable(inst, "EXPORT"))
				inst.position = pos -Vector3(0,pos.y,0)
				inst.rotation = get_node("Previews/" + item).rotation
				$Objects.add_child(inst)
				objnodes.append(inst)
				trackid += 1 
	elif !Input.is_action_pressed("yrotate"):
		$Previews.hide()
	get_input(delta)
	update_buttons()

func update_buttons():
	$CanvasLayer/trackoptions/forward.disabled = not backwards
	$CanvasLayer/trackoptions/back.disabled = backwards

func _notification(what): #if game quit
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if Options.saveonexit == true:
			save()
		get_tree().quit() # default behavior

func get_input(delta):
	# not with action_pressed so we can make buttons work
	if Input.is_action_just_pressed("backwards"):
		backwards = true
	elif Input.is_action_just_released("backwards"):
		backwards = false
	
	if Input.is_action_just_pressed("tab"):
		swap_mode()
		return
	elif Input.is_action_just_pressed("enter"):
		$Camera3D.paused = false
		for node in get_tree().get_nodes_in_group("enter"):#any node that wants release focus when entered
			node.release_focus()
	elif Input.is_action_just_pressed("Copy"):
		await save()
		$nonmoving/AnimationPlayer.play("copied")
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
	elif Input.is_action_just_pressed("export"):
		save()
		if $nonmoving/name.text == "":
			OS.shell_open(str("file://" + ProjectSettings.globalize_path(Options.filepath) + "/untitled" + ".txt"))
		else:
			OS.shell_open(str("file://" + ProjectSettings.globalize_path(Options.filepath) + "/" + $nonmoving/name.text + ".txt"))
	elif Input.is_action_just_pressed("save"):
		save()
	elif Input.is_action_just_pressed("shift"):
		shift = not shift
	elif Input.is_action_just_pressed("esc"):
		if Options.saveonexit == true:
			save()
		get_tree().change_scene_to_file("res://title.tscn")
	elif Input.is_action_just_pressed("redo"):
		_on_redo_pressed()
	elif Input.is_action_just_pressed("Undo"):
		_on_undo_pressed()
	elif Input.is_action_just_pressed("koolcam"):
		if $Camera3D.current == true:
			$cameraAnimation.play("whole track_IN")
		else:
			$cameraAnimation.play("whole track_OUT")
			
			
		
		

func highlighttrack(track):
	if track.get_node_or_null("RootNode/road") != null:
		for node in get_tree().get_nodes_in_group("track"):
			if node.get_node_or_null("RootNode/road") != null:
				node.get_node("RootNode/road").material_overlay = null
		track.get_node("RootNode/road").material_overlay = load("res://track select.tres")

func save():
	if namefocus == true: # don't save while entering a name
		return
	
	var path = Options.filepath + "/" + $nonmoving/name.text + ".txt"
	if $nonmoving/name.text == "":
		path = Options.filepath + "/" + Options.defaultfilename + ".txt"
	filename = $nonmoving/name.text
	$nonmoving/AnimationPlayer.play("saving")
	emit_signal("EXPORT")
	var file = FileAccess.open(path,FileAccess.WRITE)
	var text = map + track + objects + rails + end
	if file.open(path, file.WRITE):
		file.open(path, file.WRITE)
		for content in text:
			file.store_line(content)
		file.close()
	track = []
	$nonmoving/AnimationPlayer.play("saved")
	
	




func cam2in():
	cam2 = "in"


func cam2out():
	$Camera2.position = $Camera3D.position
	cam2 = "out"



func _on_delay_timeout():
	$audio/clack.play()




func _on_delete_pressed():
	if mode == "track":
		if current != $Track:
			nodes.remove_at(nodes.find(current))
			current.queue_free()
			if nodes.size() != 0:
				current = nodes[nodes.size() - 1]
				highlighttrack(current)


func _on_testoffset_text_changed(new_text):
	startinst.position.x = int(new_text)
	$Track/offset.position.z = int(new_text) + 4675

func offset_button_pressed(offset):
	startinst.position.x = offset
	$Track/offset.position.z = offset + 4675


func _on_forward_pressed():
	backwards = false


func _on_backwards_pressed():
	backwards = true


func _on_undo_pressed():
	if mode == "track":
		if nodes.size() != 0:
			var stored = nodes[nodes.size() - 1]
			nodes[nodes.size()-1].get_node("AnimationPlayer").play("undo")
			
			self.disconnect("EXPORT", Callable(nodes[nodes.size() - 1], "EXPORT"))
			stored.reparent($Track/redo,true)
			redotrack.append(stored)
			stored.hide()
			nodes.remove_at(nodes.size() - 1)
			if nodes.size() != 0:
				current = nodes[nodes.size()-1]
			else:
				current = $Track
			highlighttrack(current)
	if mode == "object":
		if objnodes.size() != 0:
			var stored = objnodes[objnodes.size() - 1]
			self.disconnect("EXPORT", Callable(objnodes[objnodes.size() - 1], "EXPORT"))
			stored.reparent($Objects/redo,true)
			redoobj.append(stored)
			stored.hide()
			objnodes.remove_at(objnodes.size() - 1)


func _on_redo_pressed():
	if mode == "track":
		if redotrack.size() != 0:
			var stored = redotrack[redotrack.size()-1]
			self.connect("EXPORT", Callable(stored, "EXPORT"))
			stored.get_node("AnimationPlayer").play("RESET")
			await(stored.get_node("AnimationPlayer").animation_finished)
			stored.get_node("AnimationPlayer").play("add")
			stored.reparent($Track,true)
			redotrack.remove_at(redotrack.size()-1)
			stored.show()
			nodes.append(stored)
			current = nodes[nodes.size()-1]
			highlighttrack(current)
	if mode == "object":
		if redoobj.size() != 0:
			var stored = redoobj[redoobj.size()-1]
			self.connect("EXPORT", Callable(stored, "EXPORT"))
			stored.reparent($Objects,true)
			redoobj.remove_at(redoobj.size()-1)
			stored.show()
			objnodes.append(stored)


func rotate_clockwise():
	if mode == "object":
		if item != "none":
			get_node("Previews/" + item).rotation_degrees.y -= 15


func rotate_counterclockwise():
	if mode == "object":
		if item != "none":
			get_node("Previews/" + item).rotation_degrees.y += 15


func _on_auto_movelevel(Pos):
	var distance: Vector3 = Pos - startinst.global_position
	print(distance)
	startinst.global_position.z = Pos.z
	for child in $Track.get_children():
		if not child.is_in_group("ignore"):
			child.global_position.z += distance.z
	for child in $Objects.get_children():
		if not child.is_in_group("ignore"):
			child.global_position.z += distance.z


func EditProperties(data, node):
	var text = load("res://UpdateLineText.tscn")
	
	editednode = node
	
	for child in PropertyDataContainer.get_children():
		child.queue_free()
	for line in data:
		var inst = text.instantiate()
		inst.editable = true
		inst.text = line
		PropertyDataContainer.add_child(inst)
	$nonmoving/Properties.show()


func _on_Datadone_pressed():
	var newdata: PackedStringArray = []
	for child in PropertyDataContainer.get_children():
		newdata.append(child.text)
	editednode.data = newdata
	editednode.reposition()
	$nonmoving/Properties.hide()


func swap_mode():
	if mode == "track":
		mode = "object"
		$uiAnimaiton.play("done->export")
		for node in get_tree().get_nodes_in_group("track"):
			node.get_node("RootNode/road").material_overlay = null
	elif mode == "object":
		for buttons in get_tree().get_nodes_in_group("button"):
			buttons.disabled = false
		mode = "track"
		$uiAnimaiton.play("done<-export")
		highlighttrack(current)
