extends Panel

@onready var RotationText = {"x":$TabContainer/Properties/Rotation/X,"y":$TabContainer/Properties/Rotation/Y,"z":$TabContainer/Properties/Rotation/Z}
@onready var PositionText = {"x":$TabContainer/Properties/Position/X,"y":$TabContainer/Properties/Position/Y,"z":$TabContainer/Properties/Position/Z}
@onready var ParamText = [$"TabContainer/Properties/Parameters/0-5/0",
$"TabContainer/Properties/Parameters/0-5/1",
$"TabContainer/Properties/Parameters/0-5/2",
$"TabContainer/Properties/Parameters/0-5/3",
$"TabContainer/Properties/Parameters/0-5/4",
$"TabContainer/Properties/Parameters/0-5/5",
$"TabContainer/Properties/Parameters/6-11/6",
$"TabContainer/Properties/Parameters/6-11/7",
$"TabContainer/Properties/Parameters/6-11/8",
$"TabContainer/Properties/Parameters/6-11/9",
$"TabContainer/Properties/Parameters/6-11/10",
$"TabContainer/Properties/Parameters/6-11/11"]
