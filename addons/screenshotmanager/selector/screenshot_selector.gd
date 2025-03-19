class_name ScreenshotSelector
extends Window

signal selected(path:String, image:Image, texture:ImageTexture)

@onready var _flow = $SC/HF

func _ready():
	_clear()

func _clear():
	for c in _flow.get_children():
		c.queue_free()
	hide()

func start_selection():
	var sh : Array = ScreenshotManager.get_all_screenshots()
	for shot in sh:
		var b := TextureButton.new()
		_flow.add_child(b)
		b.size_flags_horizontal = b.SIZE_EXPAND_FILL
		b.stretch_mode = b.STRETCH_KEEP_ASPECT_CENTERED
		var texture := ImageTexture.create_from_image(shot["image"])
		texture.set_size_override(shot["image"].get_size()*0.20)
		b.texture_normal = texture
		b.pressed.connect(_on_selected.bind(shot, texture))
	popup_centered_ratio()


func _on_selected(data:Dictionary, texture:ImageTexture):
	_clear()
	selected.emit(data["path"], data["image"], texture)


func _on_close_requested():
	_clear()
