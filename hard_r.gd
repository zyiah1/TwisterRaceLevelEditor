extends Node3D

@onready var creator = Options.creator
@onready var id = creator.nodes.size()
@onready var offset = get_node("offset")
var data
@onready var trackid = creator.trackid

func _ready():
	position += Vector3(-350,0,-350)
	$offset.position += Vector3(-350,0,-350)



func EXPORT():
	data = [
"          - comment: !l -1",
"            dir_x: 0.00000",
"            dir_y: 90.00000",
"            dir_z: 0.00000",
"            id_name: obj" + str(trackid),
"            layer: LC",
"            link_info: []",
"            link_num: !l 0",
"            name: Fzr_FieldParts14",
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
"            pos_x: "+str(global_position.x),
"            pos_y: "+str(global_position.y),
"            pos_z: "+str(global_position.z),
"            scale_x: 1.00000",
"            scale_y: 1.00000",
"            scale_z: 1.00000"]
	creator.track += data


