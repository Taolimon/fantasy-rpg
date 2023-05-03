extends CanvasLayer

onready var scene_switcher = get_parent()

func _on_RestartButton_pressed():
	scene_switcher.goto_level(scene_switcher.getPreviousLevel())

func _on_QuitButton_pressed():
	get_tree().quit()
