extends Node

# Level Switcher inpsired by jmbiv and godot docs
# https://www.youtube.com/watch?v=XHbrKdsZrxY
onready var _current_level = $TitleScreen
onready var _current_level_data = _current_level.get_node("LevelData")
var save_state = false
var previous_level = null
var previous_dest = null

func _ready():
	_current_level.connect("level_change", self, "processNextLevel")
	_current_level.connect("saveState", self, "setLevelSaveState")

func processNextLevel(current_level, dest, battle, world_num):
	var next_level
	var next_level_num
	_current_level = current_level
	print(world_num)
	
	
	match dest:
		"game_over":
			next_level_num = world_num
			next_level = load("res://ui/game_over.tscn").instance()
			previous_level = load("res://battle/" + previous_dest + "-battle.tscn").instance()
			previous_level.setBattleNumber(world_num)
			previous_level.setWorldNumber(next_level_num)
			previous_level.connect("level_change", self, "processNextLevel")
			goto_level(next_level)
			return
		"restart":
			next_level = previous_level
			
#	print("DEFAULT LEVEL CHANGE")
	
	if (battle):
		print("REACHED")
		next_level_num = world_num
		next_level = load("res://battle/" + dest + "-battle.tscn").instance()
		next_level.setBattleNumber(world_num)
	else:
		next_level_num = world_num
		print(dest + "-" + str(world_num) + "-world.tscn")
		next_level = load("res://overworld/" + dest + "-" + str(world_num) + "-world.tscn").instance()
		
	#saves the position of the player when transitioning
	#back into the overworld	
	if (save_state && not battle):
		next_level.setSavedLevel(true)
		save_state = false
		
	next_level.setWorldNumber(next_level_num)
	previous_level = load("res://battle/" + dest + "-battle.tscn").instance()
	previous_dest = dest	
	goto_level(next_level)

func goto_level(next_level):
	call_deferred("_deferred_goto_level", next_level)
	
func _deferred_goto_level(next_level):
	add_child(next_level)
	_current_level.queue_free()
	_current_level = next_level
	_current_level_data = _current_level.get_node("LevelData")
	print("CURRENT LEVEL DATA" + str(_current_level_data))
	_current_level.connect("level_change", self, "processNextLevel")
	_current_level.connect("saveState", self, "setLevelSaveState")
	
func setLevelSaveState(level_save):
	save_state = level_save
	
func getPreviousLevel():
	return previous_level
