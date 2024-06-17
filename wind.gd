extends Node3D

@onready var creator = Options.creator
@onready var id = creator.nodes.size()
var data
@onready var trackid = creator.trackid
var small = false

func _ready():
	if small == true:
		$windBig.hide()
		$windSmall.show()


func _physics_process(delta):
	id = creator.nodes.find(self)
	if visible == false:
		if Input.is_action_just_pressed("add"):
			creator.trackid -= 1
			queue_free()


func EXPORT():
	data = [
"          - comment: !l -1",
"            dir_x: 0.00000",
"            dir_y: 0.00000",
"            dir_z: 0.00000",
"            id_name: obj" + str(trackid),
"            layer: LC",
"            link_info: []",
"            link_num: !l 0",
"            name: Fzr_Wind",
"            param0: -1.00000",
"            param1: 1.00000",#either big or small 1 = big -1 = small
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
	if small == true:
		data[10] = "            param1: -1.00000"
	creator.track += data






func _on_area_3d_area_entered(area):
	hide()


func _on_area_3d_area_exited(area):
	show()