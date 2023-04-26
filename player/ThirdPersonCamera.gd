extends Camera


export(NodePath) var player

export var distance = 4.0
export var height = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)
	pass

func freeformCamera():
	var player_position = get_node(player).transform.origin
	var camera_position = get_global_transform_interpolated().origin
	var up = Vector3(0,1,0)

	var offset = camera_position - player_position

	offset = offset.normalized() * distance
	offset.y = height

	look_at_from_position(camera_position, player_position, up)


func _physics_process(_delta):
	freeformCamera()
