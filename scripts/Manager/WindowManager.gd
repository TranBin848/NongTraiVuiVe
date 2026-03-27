extends Node

var shop_window_scene = preload("res://scenes/UI/ShopWindow.tscn")
var shop_window_instance: SubWindow = null

func _ready() -> void:
	# Đóng vai trò cực kì quan trọng: Thiết lập ngắt nhúng cửa sổ phụ vào cửa sổ chính
	get_viewport().set_embedding_subwindows(false)
	
	# Khởi tạo trước cửa sổ Shop
	_instantiate_windows.call_deferred()

func _instantiate_windows() -> void:
	if shop_window_instance == null:
		shop_window_instance = shop_window_scene.instantiate()
		get_tree().root.add_child(shop_window_instance)

func open_shop() -> void:
	if shop_window_instance != null:
		if not shop_window_instance.visible:
			# Đặt tạm vị trí giữa màn hình
			var screen_id = DisplayServer.window_get_current_screen()
			var usable_rect = DisplayServer.screen_get_usable_rect(screen_id)
			var win_size = shop_window_instance.size
			var center_pos = usable_rect.position + (usable_rect.size / 2) - (win_size / 2)
			shop_window_instance.position = center_pos
		
		shop_window_instance.open_window()
