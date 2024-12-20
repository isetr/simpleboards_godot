@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type(
		"SimpleBoardsApi",
		"Node",
		preload("res://addons/simpleboards_plugin/SimpleBoardsApi.gd"),
		null
	)

func _exit_tree():
	remove_custom_type("SimpleBoardsApi")
