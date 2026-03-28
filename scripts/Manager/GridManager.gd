extends Node2D

const SLOT_SIZE: float = 32.0
const SLOT_COUNT: int = 80 # Rộng tối đa 80 * 32 = 2560px


var slots: Array = []
var show_grid: bool = true

func _ready() -> void:
	z_index = 4096 # Đẩy lưới lên vẽ trên cùng để không bị đối tượng khác che lúc test
	
	# Khởi tạo mảng rỗng cho từng ô đất
	slots.resize(SLOT_COUNT)
	for i in range(SLOT_COUNT):
		slots[i] = []

func _process(delta: float) -> void:
	# Ép vòng lặp vẽ lại liên tục để phục vụ hàm _draw()
	if show_grid:
		queue_redraw()

func _draw() -> void:
	if not show_grid:
		return
	
	# Phủ vài chục vạch kẻ dọc làm lưới toán học mờ
	var h = get_viewport_rect().size.y
	for i in range(SLOT_COUNT + 1):
		var x = i * SLOT_SIZE
		draw_line(Vector2(x, 0), Vector2(x, h), Color(1, 0, 0, 0.6), 2.0)

	# Bật Chế Độ Vẽ Quét (Highlight) ô 땅 đang đc nhắm tới
	var dragged = InventoryManager.dragged_item
	if dragged != null and dragged.item_id.begins_with("building_"):
		var mouse_x = get_global_mouse_position().x
		var b_type = dragged.item_id.replace("building_", "").to_int() as EnumType.Building
		
		# Lấy thông tin kích thước và ảnh từ kho Config
		var config = ConfigManager.get_building_config(b_type)
		var b_size = config.building_size if config != null else 1
		var b_tex = config.texture if config != null else null
		
		var slot_idx = get_slot_index(mouse_x)
		var is_available = is_slot_available(slot_idx, b_size)
		
		# Bơm màu Xanh trong vắt nếu mặt đất bằng phẳng, phủ Đỏ tàn bạo nếu đất có giang hồ gác!
		var color = Color(1.0, 1.0, 1.0, 0.6) if is_available else Color(1.0, 0.2, 0.2, 0.6)
		if is_available:
			color = Color(0.8, 1.0, 0.8, 0.7) # Mạ màu ánh xanh thân thiện
			
		var center_x = get_slot_position(slot_idx, b_size)
		
		if b_tex:
			# Bản in 3D: Lắp nhà đúng vào đệm theo chiều ngang và bệ xuống sàn h.
			var tw = b_tex.get_width()
			var th = b_tex.get_height()
			var dest_rect = Rect2(center_x - tw/2.0, h - th, tw, th)
			draw_texture_rect(b_tex, dest_rect, false, color)
		else:
			# Fallback lỡ như tòa nhà đéo có hình
			var rect_x = slot_idx * SLOT_SIZE
			var preview_rect = Rect2(rect_x, 0, SLOT_SIZE * b_size, h)
			draw_rect(preview_rect, color)


# Chuyển đổi: Tọa độ Chuột X -> Số thứ tự Ô Đất (0 đến 39)
func get_slot_index(x_pos: float) -> int:
	var idx = int(x_pos / SLOT_SIZE)
	return clamp(idx, 0, SLOT_COUNT - 1)

# Chuyển đổi ngược: Số thứ tự Ô Đất -> Tọa độ X ngay Lõi Trung Tâm Ô Đất (để đặt nhà vào giữa)
func get_slot_position(idx: int, building_size: int = 1) -> float:
	return (idx * SLOT_SIZE) + (building_size * SLOT_SIZE) / 2.0

# Kiểm tra Lưới bị lấn: Ô từ idx -> idx + size có Nhà chưa?
func is_slot_available(idx: int, building_size: int = 1) -> bool:
	if idx < 0 or idx + building_size > SLOT_COUNT:
		return false # Vượt quá giới hạn màn hình
		
	for i in range(building_size):
		if slots[idx + i].size() > 0:
			return false # Đã có Node nào đó chiếm đóng mảnh này rồi
	return true

# Kí Sổ đỏ: Giữ quyền kiểm soát ô đất sau khi sinh Nhà thành công
func claim_slot(idx: int, building_size: int, building_node: Node) -> void:
	for i in range(building_size):
		slots[idx + i].append(building_node)
