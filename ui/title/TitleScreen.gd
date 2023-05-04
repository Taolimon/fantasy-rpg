extends CanvasLayer

onready var scene_switcher = get_parent()

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_StartButton_pressed():
	scene_switcher.processNextLevel(self, "zero", false, 0.1)

func _on_SettingsButton_pressed():
	pass # Replace with function body.
