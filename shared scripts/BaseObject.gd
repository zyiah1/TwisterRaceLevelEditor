extends Node3D

@onready var creator = Options.creator
@onready var id = creator.nodes.size()
var data: PackedStringArray
@onready var trackid = creator.trackid


@export var meshes: Array[NodePath]
@export var DataName = "Bomb"
@export var notes = ""

@export var Param0: float = -1
@export var Param1: float = -1
@export var Param10: float = -1
@export var Param11: float = -1
@export var Param2: float = -1
@export var Param3: float = -1
@export var Param4: float = -1
@export var Param5: float = -1
@export var Param6: float = -1
@export var Param7: float = -1
@export var Param8: float = -1
@export var Param9: float = -1

var hover: bool = false

signal SendData(data,node)

func _ready():
	connect("SendData",Callable(creator,"EditProperties"))

func _physics_process(delta):
	id = creator.nodes.find(self)
	
	if Input.is_action_just_pressed("click"):
		if hover == true:
			match creator.item:
				"trash":
					queue_free()
					
				"property":
					refreshData()
					emit_signal("SendData",data,self)

func reposition(): # stole this from zelda/metriod project aab
	if data.size() > 25: # random failsafe, should delete
		global_position = Vector3(float(data[21].lstrip("            pos_x: ")),float(data[22].lstrip("            pos_y: ")),float(data[23].lstrip("            pos_z: ")))
		global_rotation_degrees = Vector3(float(data[1].lstrip("            dir_x: ")),float(data[2].lstrip("            dir_y: ")),float(data[3].lstrip("            dir_z: ")))
		#if Scalable:
		#	scale = Vector3(float(data[26].lstrip("            scale_x: ")),float(data[27].lstrip("            scale_y: ")),float(data[28].lstrip("            scale_z: ")))
		var oldname = DataName
		DataName = data[8].lstrip("            name: ")
		Param0 = int(data[9].lstrip("            param0: "))
		Param1 = int(data[10].lstrip("            param1: "))
		Param10 = int(data[11].lstrip("            param10: "))
		Param11 = int(data[12].lstrip("            param11: "))
		Param2 = int(data[13].lstrip("            param2: "))
		Param3 = int(data[14].lstrip("            param3: "))
		Param4 = int(data[15].lstrip("            param4: "))
		Param5 = int(data[16].lstrip("            param5: "))
		Param6 = int(data[17].lstrip("            param6: "))
		Param7 = int(data[18].lstrip("            param7: "))
		Param8 = int(data[19].lstrip("            param8: "))
		Param9 = int(data[21].lstrip("            param9: "))
		id = int(data[4].lstrip("            id_name: obj"))
		refreshData()

func refreshData():
	data = [
"          - comment: !l -1",
"            dir_x: "+str(global_rotation_degrees.x),
"            dir_y: "+str(global_rotation_degrees.y),
"            dir_z: "+str(global_rotation_degrees.z),
"            id_name: obj" + str(trackid),
"            layer: LC",
"            link_info: []",
"            link_num: !l 0",
"            name: Fzr_"+DataName,
"            param0: "+str(Param0),
"            param1: "+str(Param1),
"            param10: "+str(Param10),
"            param11: "+str(Param11),
"            param2: "+str(Param2),
"            param3: "+str(Param3),
"            param4: "+str(Param4),
"            param5: "+str(Param5),
"            param6: "+str(Param6),
"            param7: "+str(Param7),
"            param8: "+str(Param8),
"            param9: "+str(Param9),
"            pos_x: "+str(global_position.x),
"            pos_y: "+str(global_position.y),
"            pos_z: "+str(global_position.z),
"            scale_x: 1.00000",
"            scale_y: 1.00000",
"            scale_z: 1.00000"]

func EXPORT():
	refreshData()
	creator.track += data



func _on_area_3d_area_entered(area):
	hover = true
	if creator.item == "trash":
		for path in meshes:
			get_node(path).material_overlay = load("res://textures/delete.tres")
	elif creator.item == "property":
		for path in meshes:
			get_node(path).material_overlay = load("res://textures/property.tres")

func _on_area_3d_area_exited(area):
	hover = false
	for path in meshes:
		get_node(path).material_overlay = null
