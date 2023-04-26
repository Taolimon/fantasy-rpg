extends BattleAction

class_name Combo

var _current_attack_index = 0
var _attack_landed = false setget set_attack_landed, get_attack_landed

func attack():
	var attack = get_child(_current_attack_index)
	
func cancel():
	pass
	
func advanceCombo():
	if not _attack_landed:
		return
	if _current_attack_index + 1 != 5:
		_current_attack_index += 1
	else:
		reset()
	
func reset():
	_current_attack_index = 0
	_attack_landed = false
	pass

func set_attack_landed(landed):
	_attack_landed = landed

func get_attack_landed():
	return _attack_landed
