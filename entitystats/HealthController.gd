extends Node

class_name HealthController

onready var _entity = get_parent()

export var health = 20.0
export var max_health = 20.0

signal updateUI(value, max_value)
signal half_health

#func initialise(health_val, max_health_val):
#	health = health_val
#	max_health = max_health_val

func receiveDamage(damage):
	health -= damage
	
	updateUI()
	checkHealth()
	
func updateUI():
	emit_signal("updateUI", health, max_health)

func checkHealth():
	if (health <= 0):
		die()
	elif (health <= max_health/2):
		emit_signal("half_health")

func die():
	if (_entity.is_in_group("battle_enemy")):
		print("DEAD")	
		_entity.emit_signal("defeated")
		_entity.queue_free()
	elif (_entity.is_in_group("player")):
		_entity.emit_signal("game_over")
		_entity.queue_free()
