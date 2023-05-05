extends Node

class_name LevelData

#Class to handle saving and loading the state of a level when
#switching between combat and exploration

var player_position = Vector3.ZERO
var enemy_list = []
var enemy_id_list = []
var enemy_dict = {}
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
	dest.setEnemyIDList(self.getEnemyIDList())
	dest.setEnemyDict(self.getEnemyDict())
	dest.setInteractableList(self.getInteractableList())
	dest.setBattleID(self.getBattleID())
	
func loadState(data):
	self.setPlayerPos(data.getPlayerPos())
	self.setEnemyList(data.getEnemyList())
	self.setEnemyIDList(data.getEnemyIDList())
	self.setEnemyDict(data.getEnemyDict())
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

func setEnemyIDList(en_id_list):
	enemy_id_list = en_id_list
	
func setEnemyDict(en_dic):
	enemy_dict = en_dic
	
func getPlayerPos():
	return player_position

func getEnemyList():
	return enemy_list
	
func getEnemyIDList():
	return enemy_id_list
	
func getEnemyDict():
	return enemy_dict

func getInteractableList():
	return interactable_list

func getBattleID():
	return battle_id
	
func addEnemyToList(enemy):
	enemy_list.append(enemy)
	
func markIDInEnemyList(id):
	print("HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH")
	print(str(enemy_id_list))
	for i in range(0, len(enemy_id_list)):
		print("ENEMY ID: " + str(enemy_id_list[i]))
		print("-- MARKED --")
		if (enemy_id_list[i] == id):
			enemy_dict[id] = 0
	
func removeEnemyFromList(id):
	for i in enemy_list:
		if (i.getBattleID() == id):
			enemy_list.remove(i)
