extends CharacterBody2D

@export var speed = 100.0
var target_x = 0.0
var floor_y = 0.0

func _ready():
	# 1. Tính toán vị trí mặt đất (cạnh trên của Taskbar)
	var usable_rect = DisplayServer.screen_get_usable_rect()
	
	# Lấy chiều cao của Sprite để nông dân không bị lún chân
	# Giả sử bạn dùng Sprite2D, chúng ta lấy size của texture
	var sprite_height = $Sprite2D.texture.get_size().y * $Sprite2D.scale.y
	
	# Tọa độ Y = (Đáy vùng sử dụng được) - (Một nửa hoặc cả chiều cao sprite tùy theo Offset)
	# Nếu Sprite của bạn có Centered = true (mặc định), hãy trừ đi một nửa:
	floor_y = (usable_rect.position.y + usable_rect.size.y) - (sprite_height / 2)
	
	# Nếu bạn muốn nông dân đi "trên" Taskbar một chút cho đẹp, hãy trừ thêm 5-10 pixel
	floor_y -= 2 

	# Đặt vị trí ban đầu
	position.y = floor_y
	position.x = randf_range(50, DisplayServer.screen_get_size().x - 50)
	
	_choose_new_target()

func _physics_process(delta):
	# Tính toán hướng di chuyển sang trái hoặc phải
	var direction = sign(target_x - position.x)
	
	if abs(position.x - target_x) > 5:
		velocity.x = direction * speed
		# Quay mặt Sprite sang hướng đang đi
		if direction != 0:
			$Sprite2D.flip_h = direction < 0
	else:
		velocity.x = 0
		# Nếu đã đến đích, đợi một chút rồi đi tiếp
		if randf() < 0.01: # Tỉ lệ nhỏ để bắt đầu đi tiếp mỗi frame
			_choose_new_target()
			
	move_and_slide()
	# Ép nông dân luôn dính chặt vào mặt Taskbar (đề phòng va chạm làm lệch)
	position.y = floor_y

func _choose_new_target():
	var screen_width = DisplayServer.screen_get_size().x
	target_x = randf_range(50, screen_width - 50)
