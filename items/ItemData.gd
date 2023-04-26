extends Node

class_name ItemData

export var _description = "this is a description of an item"
export var _item_name = "item"
export var effect = "e"

func get_description():
	return _description

func get_name():
	return _item_name
