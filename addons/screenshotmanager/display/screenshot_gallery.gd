extends ScrollContainer

const SINGLE_SCENE := preload("res://addons/screenshotmanager/display/single.tscn")

@onready var _fc = $FC

@export var confirm_deletion := true

var _to_delete_path := ""

func _ready():
	ScreenshotManager.screenshot_taken.connect(func(_texture): update())
	update()

func update():
	var shots :Array= ScreenshotManager.get_all_screenshots()
	# make enough single displays
	for __ in range(max(shots.size()-_fc.get_child_count(), 0)):
		var s := SINGLE_SCENE.instantiate()
		s.rename_request.connect(_on_rename_request)
		s.delete_request.connect(_on_delete_request)
		_fc.add_child(s)
	# remove any additional displays
	for i in range(shots.size(), _fc.get_child_count()):
		_fc.get_child(i).queue_free()
	# update all displays
	for i in range(shots.size()):
		_fc.get_child(i).update(shots[i])
	

func _on_delete_request(path:String):
	if confirm_deletion:
		_to_delete_path = path
		$DeleteDialog.dialog_text = (
		"Do you really want to delete \n%s\n" % 
		path.get_file().trim_suffix("."+path.get_extension())
		)
		$DeleteDialog.popup_centered()
	else:
		DirAccess.remove_absolute(path)
		update()

func _on_rename_request(old_name:String, new_name:String):
	ScreenshotManager.rename_screenshot(old_name, new_name)
	update()


func _on_delete_dialog_confirmed():
	var err := DirAccess.remove_absolute(_to_delete_path)
	if err != OK:
		push_error("Couldn't delete screenshot %s because %s" % 
		[_to_delete_path, error_string(err)])
	update()
