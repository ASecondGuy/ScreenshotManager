class_name ScreenshotManagerNode
extends Node

const SCREENSHOT_FOLDER := "user://screenshots/"

## emited right after the screenshot is taken and last_screenshot is updated
## every screenshot is a new image
signal screenshot_taken(image:Image, screenshot_name:String)

## always the last screenshot as a texture resource
## if you use this it will automatically update to the new screenshot
var last_screenshot : ImageTexture

## The folder screenshots are saved to.
## Think of it as the currently loaded savefile or profile.
## Other savefiles are ignored. leave empty to use the default folder
var savefile := ""

func _ready():
	# make default input if none is specified
	if !InputMap.has_action("screenshot"):
		push_warning("No screenshot input action. Creating default.")
		InputMap.add_action("screenshot")
		var e := InputEventKey.new()
		e.key_label = KEY_F2
		InputMap.action_add_event("screenshot", e)


func _unhandled_key_input(event):
	if event.is_action("screenshot") and event.is_pressed() and !event.is_echo():
		get_viewport().set_input_as_handled()
		take_screenshot()


# manually trigger a screenshot 
func take_screenshot():
	var img := get_viewport().get_texture().get_image()
	if is_instance_valid(last_screenshot):
		last_screenshot.set_image(img)
	else:
		last_screenshot = ImageTexture.create_from_image(img)
	
	var shot_name := "screenshot_%s.jpg" % floori(Time.get_unix_time_from_system())
	var folder := SCREENSHOT_FOLDER 
	if !savefile.is_empty():
		folder += savefile + "/"
	DirAccess.make_dir_recursive_absolute(folder)
	var err := img.save_jpg(folder+shot_name)
	if err != OK:
		push_warning("ScreenshotManager: Couldn't save screenshot because %s" % error_string(err))
	else:
		print("ScreenshotManager: Shot taken %s" % shot_name)
	screenshot_taken.emit(img, shot_name.trim_suffix(".jpg"))


# get and array of Dictionaries. One dict per screenshot with the elements: 
#  - path: static path of screenshot (usually user://screenshots/savefile/screenshot_1743023137.jpg)
#  - image: Image resource
#  - creation_time: Timestamp of creation_time
func get_all_screenshots():
	var folder := SCREENSHOT_FOLDER 
	if !savefile.is_empty():
		folder += savefile + "/"
	var files := Array(DirAccess.get_files_at(folder))
	files = files.map(func(p): return {
		"path": folder+p,
		"image": Image.load_from_file(folder+p),
		"creation_time": FileAccess.get_modified_time(folder+p)
	})
	files.sort_custom(func(a, b): return a["creation_time"] > b["creation_time"])
	files.map(func(d:Dictionary): d.make_read_only())
	return files


# names are both relative to the screenshot folder and without fileextension
func rename_screenshot(old_name:String, new_name:String) -> Error:
	var folder := SCREENSHOT_FOLDER
	if !savefile.is_empty():
		folder += savefile + "/"
	if FileAccess.file_exists(folder+new_name+".jpg"):
		return ERR_ALREADY_EXISTS
	return DirAccess.rename_absolute(folder+old_name+".jpg", folder+new_name+".jpg")


