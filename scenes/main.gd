extends Node

var is_hidden = false
var taskbar_pos = Vector2i()
var hidden_pos = Vector2i()
var window_h = 200

@onready var toggle_btn = $CanvasLayer/ToggleBtn
@onready var camera: Camera2D = $Camera2D

# === CAMERA SCROLL LOGIC ===
var _dragging: bool = false
var _last_mouse_pos: Vector2 = Vector2.ZERO
var _target_pos: Vector2 = Vector2.ZERO
var smoothing_speed: float = 8.0
var drag_sensitivity: float = 1.0

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

	if camera:
		_target_pos = camera.global_position

func _process(delta: float) -> void:
	if camera:
		var t: float = clamp(smoothing_speed * delta, 0.0, 1.0)
		camera.global_position = camera.global_position.lerp(_target_pos, t)

func _clamp_position(pos: Vector2) -> Vector2:
	var screen_w = get_viewport().get_visible_rect().size.x
	# Max cuộn = Tổng chiều dài bãi đất trừ đi chiều dài cái màn hình
	var max_x = GridManager.SLOT_COUNT * GridManager.SLOT_SIZE - screen_w
	if max_x < 0:
		max_x = 0
		
	var x = clamp(pos.x, 0.0, max_x)
	return Vector2(x, pos.y)

func _input(event: InputEvent) -> void:
	# === CAMERA SCROLL EVENT ===
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				_dragging = true
				_last_mouse_pos = event.position
			else:
				_dragging = false
				_target_pos = _clamp_position(_target_pos)

	elif event is InputEventMouseMotion and _dragging:
		var delta_vec: Vector2 = (event.position - _last_mouse_pos) * -drag_sensitivity
		_last_mouse_pos = event.position
		_target_pos.x += delta_vec.x
		_target_pos = _clamp_position(_target_pos)

	# Press B to test spawn building
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_B:
			_test_spawn_building()
		# Press S to test open Shop Window
		elif event.keycode == KEY_S:
			WindowManager.open_shop()
		# Bấm phím A để thử nghiệm vứt thêm Building vào túi
		elif event.keycode == KEY_A:
			InventoryManager.add_item("building_1", 3)
			InventoryManager.add_item("building_2", 2)

	# Bắt sự kiện Click MOUSE TRÁI để thả Nhà (Building)
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var dragged = InventoryManager.dragged_item
		if dragged != null and dragged.item_id.begins_with("building_"):
			var b_type = dragged.item_id.replace("building_", "").to_int() as EnumType.Building
			
			# Lướt Config tìm chiều rộng lấn chiếm thực tế của tòa nhà (Building Size)
			var config = ConfigManager.get_building_config(b_type)
			var b_size = config.building_size if config != null else 1
			var slot_idx: int = GridManager.get_slot_index(event.position.x)
			
			# Từ chối Xây Dựng nếu Ô (Slot) đó đã có nhà hoặc ngoài tầm bản đồ
			if GridManager.is_slot_available(slot_idx, b_size):
				
				# Móc tọa độ chính giữa tim mảnh đất để thả
				var spawn_x = GridManager.get_slot_position(slot_idx, b_size)
				
				# Gọi Công Nhân Xây 
				var building = BuildingManager.spawn_building(b_type, spawn_x)
				if building:
					# Bàn giao Sổ Đổ: Khóa Chốt Vùng Đất này.
					GridManager.claim_slot(slot_idx, b_size, building)
					
					var leftover = dragged.amount - 1
					
					# Reset Chuột
					InventoryManager.dragged_item = null
					Input.set_custom_mouse_cursor(null)
					
					# Gửi trả móng thừa
					if leftover > 0:
						InventoryManager.add_item(dragged.item_id, leftover)
						
					InventoryManager.inventory_updated.emit()
					get_viewport().set_input_as_handled()



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
