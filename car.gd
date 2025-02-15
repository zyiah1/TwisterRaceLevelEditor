extends Node3D

@onready var creator = Options.creator
@onready var id = creator.nodes.size()
var data: PackedStringArray
@onready var trackid = creator.trackid


func _physics_process(delta):
	id = creator.nodes.find(self)
	if visible == false:
		if Input.is_action_just_pressed("click"):
			creator.trackid -= 1
			queue_free()




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
"            name: Fzr_EnemyCar",
"            param0: -1.00000",
"            param1: 0.00000",
"            param10: -1.00000",
"            param11: -1.00000",
"            param2: 1.00000",
"            param3: -1.00000",
"            param4: -1.00000",
"            param5: -1.00000",
"            param6: -1.00000",
"            param7: -1.00000",
"            param8: 1.00000",
"            param9: -1.00000",
"            pos_x: "+str(global_position.x),
"            pos_y: "+str(global_position.y),
"            pos_z: "+str(global_position.z),
"            scale_x: 0.70000",
"            scale_y: 0.70000",
"            scale_z: 0.70000"]
	creator.track += data





func _on_area_3d_area_entered(area):
	hide()


func _on_area_3d_area_exited(area):
	show()


