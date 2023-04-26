extends Node

# Level Switcher inpsired by jmbiv and godot docs
# https://www.youtube.com/watch?v=XHbrKdsZrxY
onready var _current_level = $Overworld
onready var _current_level_data = $Overworld/LevelData
var save_state = false

func _ready():
	_current_level.connect("level_change", self, "processNextLevel")
	_current_level.connect("saveState", self, "setLevelSaveState")

func processNextLevel(current_level, dest, battle, world_num):
	_current_level = current_level
	var next_level
	var next_level_num
	print(world_num)
	
	if (battle):
		next_level_num = world_num
		next_level = load("res://battle/" + dest + "-battle.tscn").instance()
		next_level.setBattleNumber(world_num)
	else:
		next_level_num = world_num
		print(dest + "-" + str(world_num) + "-world.tscn")
		next_level = load("res://overworld/" + dest + "-" + str(world_num) + "-world.tscn").instance()
		
	if (save_state && not battle):
		next_level.setSavedLevel(true)
		save_state = false
		
	next_level.setWorldNumber(next_level_num)	
	goto_level(next_level)

func goto_level(next_level):
	call_deferred("_deferred_goto_level", next_level)
	
func _deferred_goto_level(next_level):
	add_child(next_level)
	_current_level.queue_free()
	_current_level = next_level
	_current_level.connect("level_change", self, "processNextLevel")
	
func setLevelSaveState(level_save):
	save_state = level_save
