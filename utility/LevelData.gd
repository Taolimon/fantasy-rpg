extends Node

class_name LevelData

#Class to handle saving and loading the state of a level when
#switching between combat and exploration

var player_position = Vector3.ZERO
var enemy_list = []
var interactable_list = []
var battle_id = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func save():
	pass

func saveState(dest : LevelData):
	dest.setPlayerPos(self.getPlayerPos())
	dest.setEnemyList(self.getEnemyList())
	dest.setInteractableList(self.getInteractableList())
	dest.setBattleID(self.getBattleID())
	
func loadState(data):
	self.setPlayerPos(data.getPlayerPos())
	self.setEnemyList(data.getEnemyList())
	self.setInteractableList(data.getInteractableList())
	self.setBattleID(data.getBattleID())
	
func setPlayerPos(player_pos):
	player_position = player_pos
	
func setEnemyList(en_list):
	enemy_list = en_list

func setInteractableList(in_list):
	interactable_list = in_list

func setBattleID(id):
	battle_id = id
	
func getPlayerPos():
	return player_position

func getEnemyList():
	return enemy_list

func getInteractableList():
	return interactable_list

func getBattleID():
	return battle_id
