extends Node


# Declare member variables here. Examples:
onready var _current_level = get_parent().get_node("Overworld")	
onready var _current_level_data : LevelData = get_parent().get_node("Overworld/LevelData")
onready var saved_level = $LevelData

#Level

# Called when the node enters the scene tree for the first time.
#func _ready():
#	_current_level.connect("sendLevelData", self, "setLevelData")
#
#func setLevelData(leveldata):
#	_current_level_data = leveldata
#
func getLevelData():
	return saved_level


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	print("HOLDING THIS: " + str(saved_level.getPlayerPos()))
