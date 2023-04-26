extends KinematicBody

class_name enemy_world

export (PackedScene) var player_scene

export var min_speed = 7
export var max_speed = 10
export var alerted = false
export var enemy_id = 0.0

onready var player = null
onready var player_position = null
onready var current_area = null
onready var spawn_location = null

func _ready():
	current_area = get_parent()
	pass

# warning-ignore:return_value_discarded
func _physics_process(_delta):
	
	#try to follow the player
	if (player != null):	
		player_position = player.transform.origin
		var direction = (player_position - transform.origin).normalized()
		look_at(player_position, Vector3.UP)
		move_and_slide(direction * max_speed, Vector3.UP)

func setEnemyPos(position):
	spawn_location = position
	transform.origin = position

func _on_PlayerDetector_body_entered(body):
	if (body != self && body.is_in_group("player")):
		player = body
		player_position = player.transform.origin

func _on_PlayerDetector_body_exited(body):
	if (body == player):
		player = null

func setEnemyID(id):
	enemy_id = id

func getEnemyID():
	return enemy_id
