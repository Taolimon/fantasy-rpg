extends Area

class_name LevelChanger

export var next_level_id = 0.2
var _current_level = get_parent()

signal levelchanger_change(id)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("levelchanger_change", _current_level, "on_LevelChanger_level_changed")

func _on_LevelChanger_body_entered(body):
	if (body.is_in_group("player")):
		emit_signal("levelchanger_change", next_level_id)
