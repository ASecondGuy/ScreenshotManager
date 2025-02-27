extends VBoxContainer

signal rename_request(old_name:String, new_name:String)
signal delete_request(path:String)

@onready var _texture_rect = $TextureRect
@onready var _name_edit = $HB/NameEdit
@onready var _delete_btn = $HB/DeleteBtn

# dict has {"path", "image", "creationtime"}
var screenshot_dict : Dictionary
var _current_name : String

func update(dict:Dictionary):
	screenshot_dict = dict
	_texture_rect.texture = ImageTexture.create_from_image(screenshot_dict["image"])
	var p : String = dict["path"]
	_current_name = p.get_file().trim_suffix("."+p.get_extension())
	_name_edit.text = _current_name

func _on_name_edit_text_submitted(new_text):
	rename_request.emit(_current_name, new_text)


func _on_delete_btn_pressed():
	delete_request.emit(screenshot_dict["path"])
