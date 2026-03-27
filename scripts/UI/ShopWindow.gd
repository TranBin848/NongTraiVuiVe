extends SubWindow

@onready var btn_close: Button = $Panel/DragArea/BtnClose
@onready var grid: GridContainer = $Panel/GridContainer
var slot_scene: PackedScene = preload("res://scenes/Inventory/InventorySlot.tscn")

func _ready() -> void:
	# Gọi hàm khởi tạo base (ẩn viền OS, cài đặt trong suốt và sự kiện kéo)
	super._ready()
	
	# Kết nối sự kiện nút đóng
	if btn_close:
		btn_close.pressed.connect(_on_btn_close_pressed)

	# Khởi tạo tự động 20 slots để lấp đầy GridContainer
	for i in range(20):
		var slot = slot_scene.instantiate()
		slot.slot_index = i
		grid.add_child(slot)
		
	# Kích hoạt một phát cập nhật UI để các slot tự hiển thị ảnh ban đầu
	InventoryManager.inventory_updated.emit()

func _on_btn_close_pressed() -> void:
	close_window()
