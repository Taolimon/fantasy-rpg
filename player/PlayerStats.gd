extends Node

class_name PlayerStats

var _attack = 0
var _attack_speed = 0
var _health = 10
var _defence = 0
var _elemental_affinity = "none"
var _level = 1
var _exp = 500
var _current_exp = 0

var levelUpVal = 2

"""
Different characters prioritise different stats when levelling up
Only attack, health and defence are increased in the general levelUp function
"""

func levelUp():
	_exp = _exp + (100 * _level)
	_level += 1
	_current_exp = 0
	
	_attack += levelUpVal
	_health += levelUpVal + _level * levelUpVal
	_defence += levelUpVal
