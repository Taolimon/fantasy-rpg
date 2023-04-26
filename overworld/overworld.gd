extends Node

export (PackedScene) var enemy_scene
export var level_name = "test"
export var num = 0.1

onready var data = $LevelData
onready var world = get_parent().get_node("WorldData")

##member variables
#general
var saved_level = false
var interactable_list = []
var rng = RandomNumberGenerator.new()
#specific
var entering_battle = false
var enemy_counter = 0.00

#signals
signal level_change(source_level, dest_level, mode)
signal saveState(level_state)
signal sendLevelData(leveldata)

# Called when the node enters the scene tree for the first time.
func _ready():
	if (saved_level):
		loadData()
	else:
		spawnRandomEnemies()
		
	print(data.getPlayerPos())

func getLevelName():
	return level_name

func setWorldNumber(number):
	num = number

func enterBattle():
	entering_battle = true
	
func spawnRandomEnemies():
	rng.randomize()
	
	var enemy = enemy_scene.instance()
	var enemy_spawn_location = get_node("SpawnPath/SpawnLocation")
#	enemy_spawn_location.unit_offset = rng.randf_range(-1.0, 0.0)
	print("ENEMY LOC: " + str(enemy.transform.origin))
	print("TRANSLACTION: " + str(enemy_spawn_location.translation))
	enemy.setEnemyPos(enemy_spawn_location.translation)
	var player_position = $Player.transform.origin
	enemy_counter += 0.01
	var enemy_num = num + enemy_counter
	enemy.setEnemyID(enemy_num)
	add_child(enemy)

func _on_Player_battleStart(id):
	print("SEND THIS: " + str($Player.transform.origin))
	data.setPlayerPos($Player.transform.origin)
	data.setInteractableList(interactable_list)
	data.setBattleID(id)
	
	print(str(get_parent().get_node("WorldData/LevelData")))
	var global_level_save = get_parent().get_node("WorldData/LevelData")
	data.saveState(global_level_save)
	
	print("RECEIVED THIS: " + str(data.getPlayerPos()))
	
	emit_signal("saveState", true)
	emit_signal("sendLevelData", data)
	emit_signal("level_change", self, level_name, true, num)
	
func setSavedLevel(saved):
	saved_level = saved

func loadData():
	print("HERE")
	data.loadState(world.getLevelData())
	processData()
	

func processData():
	if ($Player.transform.origin != null):
		$Player.transform.origin = data.getPlayerPos()
	interactable_list = data.getInteractableList()

func _on_LevelChanger_levelchanger_change(id):
	emit_signal("level_change", self, level_name, false, id)
