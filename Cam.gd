extends Camera3D

var paused: bool = false

const minzoom = 0
const maxzoom = 5000

func _physics_process(delta):
	near = position.y/1000#fix clipping
	if not get_node("../nonmoving/name").has_focus():
		if Options.trackfreecam == true or get_parent().mode != "track":
			if Input.is_action_pressed("ui_right"):
				position.z -= -1000 * position.y/500  * delta
			if Input.is_action_pressed("ui_left"):
				position.z += -1000 * position.y/500  * delta
			if Input.is_action_pressed("ui_down"):
				if not Input.is_action_pressed("save"):
					position.x += -1000 * position.y/500  * delta
			if Input.is_action_pressed("ui_up"):
				position.x -= -1000 * position.y/500 * delta
		else:
			position = position.move_toward(Options.creator.current.offset.global_position - Vector3(800,-position.y,0),1000*delta)
	if Input.is_action_just_pressed("zoomin"):
		if position.y - 200 > minzoom:
			position.y -= 200
	if Input.is_action_just_pressed("zoomout"):
		if position.y + 200 < maxzoom:
			position.y += 200
			


