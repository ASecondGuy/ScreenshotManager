@tool
extends EditorPlugin


func _enter_tree():
	# Initialization of the plugin goes here.
	add_autoload_singleton("ScreenshotManager", 
	"res://addons/screenshotmanager/screenshot_manager.gd")


func _exit_tree():
	remove_autoload_singleton("ScreenshotManager")
