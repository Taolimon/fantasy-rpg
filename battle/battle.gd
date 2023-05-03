extends Node

export (PackedScene) var battle_enemy_scene
export var level_name = "test"
export var _enemies = []
export var _number_of_enemies = 1

var world_num = 0.0
var battle_num = 0.0

#signals
signal level_change(source_level, dest_level, mode)
#signal sendBattleRewards(experience, currency, items)
#signal saveState(level_state)
signal battle_end
signal battle_entered

func _ready():
	emit_signal("battle_entered")
	
	var enemy = battle_enemy_scene.instance()
	var enemy_spawn_location = get_node("SpawnPath/SpawnLocation")
	enemy_spawn_location.unit_offset = randf()
	
	var player = $Player
	add_child(enemy)
	_enemies.append(enemy)
	if (_number_of_enemies != 1):
		_number_of_enemies += 1
	enemy.detectPlayer(player)
	enemy.connect("defeated", self, "_on_Enemy_defeated")
	
	
func _on_Enemy_defeated():
	print("BATTLE END")
	print(str(_number_of_enemies))
	print(str(_enemies))
	_enemies.remove(_enemies.size()-1)
	_number_of_enemies -= 1

	if (_number_of_enemies == 0 && _enemies.size() == 0):
		emit_signal("battle_end")
		endBattle()

func endBattle():
	emit_signal("level_change", self, level_name, false, world_num)

func setWorldNumber(number):
	world_num = number
	
func setBattleNumber(number):
	battle_num = number


func _on_Player_game_over():
	_enemies.remove(_enemies.size()-1)
	_number_of_enemies -= 1
	emit_signal("level_change", self, "game_over", false, world_num)
	pass # Replace with function body.
