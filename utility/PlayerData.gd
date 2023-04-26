extends Node

onready var _world_player = null
var _player_party = [4]
var _current_party_size = 1
var _coins_num = 10
var _character_archive = []

func addPlayer(player):
	if _current_party_size != 4:	
		_player_party.add(player)
		_current_party_size += 1

func findPlayer(player):
	for i in _player_party:
		if player == _player_party[i]:
			return _player_party[i]
			
func findPlayerID(player):
	for i in _player_party:
		if player == _player_party[i]:
			return i

func setWorldPlayer(player):
	_world_player = player

func gainCoins(amount):
	_coins_num += amount
