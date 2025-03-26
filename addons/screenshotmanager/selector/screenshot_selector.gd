class_name ScreenshotSelector
extends Window

signal selected(path:String, image:Image)

@onready var _flow = $SC/HF

func _ready():
	_clear()

func _clear():
	for c in _flow.get_children():
		c.queue_free()
	hide()

func start_selection():
	popup_centered_ratio()
	var sh : Array = ScreenshotManager.get_all_screenshots()
	#desired screenshot width is 20% of the screen
	var sh_width : float = get_window().size.x*0.2
	for shot in sh:
		var b := TextureButton.new()
		_flow.add_child(b)
		b.size_flags_horizontal = b.SIZE_EXPAND_FILL
		b.stretch_mode = b.STRETCH_KEEP_ASPECT_CENTERED
		b.tooltip_text = (shot["path"] as String).get_file().split(".")[0]
		var texture := ImageTexture.create_from_image(shot["image"])
		# how much to resize so the screenshot has wanted width
		var mult : float = sh_width/shot["image"].get_size().x
		texture.set_size_override(shot["image"].get_size()*mult)
		b.texture_normal = texture
		b.pressed.connect(_on_selected.bind(shot))


func _on_selected(data:Dictionary):
	_clear()
	selected.emit(data["path"], data["image"])


func _on_close_requested():
	_clear()
