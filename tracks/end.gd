extends Node3D

@onready var creator = Options.creator
@onready var id = creator.nodes.size()
@onready var offset = get_node("offset")
var data
@onready var trackid = creator.trackid


func applyoffset():
	add_to_group("track")
	position.z -= 700


func EXPORT():
	data = ["          - comment: !l -1",
"            dir_x: 0.00000",
"            dir_y: 270.00000",
"            dir_z: 0.00000",
"            id_name: obj1",
"            layer: LC",
"            link_info: []",
"            link_num: !l 0",
"            name: Fzr_GoalLine",
"            param0: 0.00000",
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
"            scale_x: 200.00000",
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
"            pos_x: "+str(global_position.x-10900),
"            pos_y: "+str(global_position.y),
"            pos_z: "+str(global_position.z),
"            scale_x: 200.00000",
"            scale_y: 1.00000",
"            scale_z: 1.00000"]
	creator.track += data
