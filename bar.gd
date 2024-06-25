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

func _physics_process(delta):
	id = creator.nodes.find(self)
	if hover == true:
		if creator.item == "trash":
			if Input.is_action_just_pressed("click"):
				queue_free()
	if Param1 == 1:
		$bardown.show()
		$barup.hide()
	if Param1 == -1:
		$bardown.hide()
		$barup.show()

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
"            scale_x: 1.00000",
"            scale_y: 1.00000",
"            scale_z: 1.00000"]
	creator.track += data


func _on_area_3d_area_entered(area):
	hover = true
	if creator.item == "trash":
		for path in meshes:
			get_node(path).material_overlay = load("res://textures/delete.tres")


func _on_area_3d_area_exited(area):
	hover = false
	for path in meshes:
		get_node(path).material_overlay = null
