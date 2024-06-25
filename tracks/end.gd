extends Node3D


@onready var creator = Options.creator
@onready var id = creator.nodes.size()
@onready var offset = get_node_or_null("offset")
@onready var trackid = creator.trackid

@export var DataName = "GoalLine"
@export var notes = ""

@export var Param0: float = 0
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

@export var positionoffset: Vector3 = Vector3.ZERO

var data: PackedStringArray

func applyoffset():
	add_to_group("track")
	if positionoffset != Vector3.ZERO:
		position += positionoffset

func EXPORT():
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
"            scale_x: 200.00000",
"            scale_y: 1.00000",
"            scale_z: 1.00000"]
	creator.track += data


