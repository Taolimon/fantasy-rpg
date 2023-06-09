extends KinematicBody

export (PackedScene) var player_scene

export var enemy_name = "knight"
export var min_speed = 7
export var max_speed = 10
export var alerted = false
export var enemy_id = 0.0

onready var player = null
onready var player_position = null
onready var current_area = null
onready var spawn_location = null
onready var level_data = get_parent().get_node("LevelData")
onready var parent_level = get_parent()

onready var armature = $"guard-v0/rig/Skeleton/Cube001"
onready var spear = $"guard-v0/Armature"
onready var anim_tree = $"guard-v0/AnimationTree"
onready var playback = anim_tree.get("parameters/playback")

var updating = false

func _ready():
	var enemy_list = parent_level.getEnemyList()
	var enemy_id_list = parent_level.getEnemyIDList()
	var enemy_dic = parent_level.getEnemyDict()
	
	enemy_list.append(self)
	enemy_id_list.append(enemy_id)
	enemy_dic[enemy_id] = 1
	print("ADDED" + str( enemy_id_list))
	parent_level.setEnemyList(enemy_list)
	parent_level.setEnemyIDList(enemy_id_list)
	parent_level.setEnemyDict(enemy_dic)
	print("EIDL: " + str(parent_level.getEnemyIDList()))
	
	playback.start("guard")
	anim_tree.active = true
	current_area = get_parent()
	pass

# warning-ignore:return_value_discarded
func _physics_process(_delta):
	var enemy_dic = parent_level.getEnemyDict()
	if (updating && enemy_dic[enemy_id] == 0):
		self.queue_free()
		updating = false

	#try to follow the player
	if (player != null):	
		player_position = player.transform.origin
		var direction = (player_position - transform.origin).normalized()
		look_at(player_position, Vector3.UP)
		move_and_slide(direction * max_speed, Vector3.UP)
		playback.travel("walk-loop")

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
		playback.travel("guard")

func setEnemyID(id):
	enemy_id = id

func getEnemyID():
	return enemy_id
	
func getEnemyName():
	return enemy_name


func _on_Overworld_updateEnemy(value):
	updating = true
