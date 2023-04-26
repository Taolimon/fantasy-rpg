extends Node

class_name StanceController

onready var _entity = get_parent()
var stance = 10

func receiveDamage(damage):
	stance -= damage

func checkStance():
	if (stance <= 0):
		downed()

func downed():
	print("DOWN")
	_entity.downed = true
	emit_signal("enemy_down")
