extends Node

const SCREENSHOT_FOLDER := "user://screenshots/"

## emited right after the screenshot is taken
signal screenshot_taken(texture:Texture2D)

## always the last screenshot as a texture resource
var last_screenshot : Texture2D

## The folder screenshots are saved to.
## Think of it as the currently loaded savefile or profile.
## Other savefiles are ignored. leave empty to 
var savefile := ""

func _ready():
	# make default input if none is specified
	if !InputMap.has_action("screenshot"):
		InputMap.add_action("screenshot")
		var e := InputEventKey.new()
		e.key_label = KEY_F2
		InputMap.action_add_event("screenshot", e)


func _unhandled_key_input(event):
	if event.is_action("screenshot") and event.is_pressed() and !event.is_echo():
		get_viewport().set_input_as_handled()
		var img := get_viewport().get_texture().get_image()
		var text := ImageTexture.create_from_image(img)
		last_screenshot = text
		screenshot_taken.emit(text)
		var shot_name := "screenshot_%s.jpg" % floori(Time.get_unix_time_from_system())
		var folder := SCREENSHOT_FOLDER 
		if !savefile.is_empty():
			folder += savefile + "/"
		DirAccess.make_dir_recursive_absolute(folder)
		var err := text.get_image().save_jpg(folder+shot_name)
		if err != OK:
			push_warning("ScreenshotManager: Couldn't save screenshot because %s" % error_string(err))


func get_all_screenshots():
	var folder := SCREENSHOT_FOLDER 
	if !savefile.is_empty():
		folder += savefile + "/"
	var files := Array(DirAccess.get_files_at(folder))
	files = files.map(func(p): return {
		"path": folder+p,
		"image": Image.load_from_file(folder+p),
		"creationtime": FileAccess.get_modified_time(folder+p)
	})
	files.sort_custom(func(a, b): return a["creationtime"] > b["creationtime"])
	files.map(func(d:Dictionary): d.make_read_only())
	return files

func rename_screenshot(old_name:String, new_name:String) -> Error:
	var folder := SCREENSHOT_FOLDER
	if !savefile.is_empty():
		folder += savefile + "/"
	if FileAccess.file_exists(folder+new_name+".jpg"):
		return ERR_ALREADY_EXISTS
	return DirAccess.rename_absolute(folder+old_name+".jpg", folder+new_name+".jpg")


