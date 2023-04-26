extends Sprite3D

onready var _bar = $Viewport/EnemyHealthBar/TextureProgress

func _ready():
	texture = $Viewport.get_texture()

func update(value, max_value):
	_bar.value = (value * 100)
	print(str(_bar.value))


func _on_HealthController_updateUI(value, max_value):
	update(value, max_value)
