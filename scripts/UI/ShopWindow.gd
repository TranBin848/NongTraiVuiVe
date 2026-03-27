extends SubWindow

@onready var btn_close: Button = $Panel/DragArea/BtnClose

func _ready() -> void:
	# Gọi hàm khởi tạo base (ẩn viền OS, cài đặt trong suốt và sự kiện kéo)
	super._ready()
	
	# Kết nối sự kiện nút đóng
	if btn_close:
		btn_close.pressed.connect(_on_btn_close_pressed)

func _on_btn_close_pressed() -> void:
	close_window()
