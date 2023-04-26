extends StaticBody

class_name Interactable

onready var interact_area = $InteractArea
var text

signal display_dialog(text)

func displayDialog():
	emit_signal("display_dialog", text)
