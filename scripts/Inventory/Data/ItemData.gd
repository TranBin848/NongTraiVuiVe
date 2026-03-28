extends Resource
class_name ItemData

@export var item_id: String = ""
@export var amount: int = 0
@export var max_stack: int = 99

func _init(_id: String = "", _amount: int = 1) -> void:
	item_id = _id
	amount = _amount

func get_texture() -> Texture2D:
	if item_id.begins_with("building_"):
		var b_id = item_id.replace("building_", "").to_int()
		var config = ConfigManager.get_building_config(b_id as EnumType.Building)
		if config and config.get("texture"):
			return config.texture
			
	# Tạm dùng icon mặc định của Godot. Sau này bạn chỉ cần check id để load file ảnh tương ứng.
	return load("res://icon.svg") 

func get_cursor_texture() -> Texture2D:
	# Scale nhỏ ảnh lại cữ 32x32 để vừa khung con trỏ chuột (tránh cái ảnh 128x128 mặc định)
	var tex = get_texture()
	var img = tex.get_image()
	if img.get_width() > 32 or img.get_height() > 32:
		img.resize(32, 32, Image.INTERPOLATE_BILINEAR)
		return ImageTexture.create_from_image(img)
	return tex

func clone() -> ItemData:
	var copy = ItemData.new(item_id, amount)
	copy.max_stack = max_stack
	return copy
