extends Node

var is_hidden = false
var taskbar_pos = Vector2i()
var hidden_pos = Vector2i()
var window_h = 200

@onready var toggle_btn = $CanvasLayer/ToggleBtn

func _ready():
	var screen_id = DisplayServer.window_get_current_screen()
	var usable_rect = DisplayServer.screen_get_usable_rect(screen_id)

	# Chiều rộng bằng màn hình, chiều cao 240px
	DisplayServer.window_set_size(Vector2i(usable_rect.size.x, window_h))

	# 1. Vị trí lúc đang hiện (ngay trên taskbar)
	taskbar_pos = Vector2i(usable_rect.position.x, usable_rect.position.y + usable_rect.size.y - window_h)

	# 2. Vị trí lúc ẩn: Trượt xuống sâu đến mức chỉ còn cái nút ở y=0 lòi ra trên taskbar
	# Chúng ta đẩy toàn bộ cửa sổ xuống dưới mép usable_rect.size.y
	# nhưng chừa lại một khoảng bằng chiều cao của nút
	var btn_height = int(toggle_btn.size.y)
	hidden_pos = Vector2i(taskbar_pos.x, usable_rect.position.y + usable_rect.size.y - btn_height)

	DisplayServer.window_set_position(taskbar_pos)
	toggle_btn.pressed.connect(_on_toggle_btn_pressed)

	# Đặt Pivot của nút vào giữa để xoay/lật cho đẹp
	toggle_btn.pivot_offset = toggle_btn.size / 2


func _input(event: InputEvent) -> void:
	# Press B to test spawn building
	if event is InputEventKey and event.pressed and event.keycode == KEY_B:
		_test_spawn_building()


func _test_spawn_building() -> void:
	# Spawn a House1 building at random X position
	var random_x = randf_range(200, get_window().size.x - 200)
	var building = BuildingManager.spawn_building(EnumType.Building.HOUSE_1, random_x)
	if building:
		print("Spawned building at x=", random_x)
	else:
		print("Failed to spawn building")


# Giả sử bạn đặt tên node icon là $ToggleBtn/Sprite2D
func _on_toggle_btn_pressed():
	var tween = create_tween().set_parallel(true)
	var icon = $CanvasLayer/ToggleBtn/Sprite2D # Đường dẫn đến icon của bạn
	
	if is_hidden:
		tween.tween_method(func(pos): DisplayServer.window_set_position(pos), 
			DisplayServer.window_get_position(), taskbar_pos, 0.4).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		
		# Lật icon về hướng xuống (0 độ)
		tween.tween_property(icon, "rotation_degrees", 0, 0.3)
	else:
		tween.tween_method(func(pos): DisplayServer.window_set_position(pos), 
			DisplayServer.window_get_position(), hidden_pos, 0.4).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		
		# Xoay icon 180 độ để hướng lên
		tween.tween_property(icon, "rotation_degrees", 180, 0.3)
		
	is_hidden = !is_hidden
