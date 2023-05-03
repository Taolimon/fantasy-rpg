extends Control

onready var _health_bar = $Bars/HealthBar/TextureProgress
onready var _health_text = $Bars/HealthBar/Counter/Label

func updateHealthBar(value, max_value):
	var val = value/max_value
	var max_val = max_value/max_value
	_health_bar.value = (val * 100)
	_health_text.text = str(value) + "/" + str(max_value)

func _on_HealthController_updateUI(value, max_value):
	updateHealthBar(value, max_value)
