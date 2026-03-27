extends Window
class_name SubWindow

var dragging: bool = false
var drag_start_pos: Vector2 = Vector2()
var window_id: int

@export var drag_area: Control

func _ready() -> void:
	# Đăng ký sự kiện kéo cửa sổ
	if drag_area:
		drag_area.gui_input.connect(_on_drag_area_gui_input)

func _setup_window_flags() -> void:
	window_id = _get_window_id()
	
	# Kích hoạt Borderless (Xoá viền Hệ điều hành Windows mặc định)
	DisplayServer.window_set_flag(DisplayServer.WindowFlags.WINDOW_FLAG_BORDERLESS, true, window_id)
	
	# Bật trong suốt nền nếu được hỗ trợ
	if DisplayServer.has_feature(DisplayServer.Feature.FEATURE_WINDOW_TRANSPARENCY):
		DisplayServer.window_set_flag(DisplayServer.WindowFlags.WINDOW_FLAG_TRANSPARENT, true, window_id)
		get_viewport().transparent_bg = true

func _get_window_id() -> int:
	var windows: Array = DisplayServer.get_window_list()
	# Thường thì window cuối cùng trong danh sách sẽ là cái vừa mở mới nhất
	return windows[windows.size() - 1]

func _on_drag_area_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				drag_start_pos = event.position
			else:
				dragging = false
	elif event is InputEventMouseMotion and dragging:
		var global_mouse_pos: Vector2 = Vector2(position) + event.position
		var new_pos: Vector2 = global_mouse_pos - drag_start_pos
		DisplayServer.window_set_position(new_pos, window_id)
		
func open_window() -> void:
	visible = true
	await get_tree().process_frame
	_setup_window_flags()

func close_window() -> void:
	visible = false
