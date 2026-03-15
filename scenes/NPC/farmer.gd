extends CharacterBody2D

@export var speed = 80.0
var target_x = 0.0
var floor_y = 0.0
var farmer_height = 0.0 

@onready var anim = $AnimatedSprite2D
@onready var col_shape: CollisionShape2D = $CollisionShape2D

func _ready():
	await get_tree().process_frame
	
	_update_floor_position()
	
	# Đặt vị trí X ngẫu nhiên trong màn hình
	global_position.x = randf_range(50, get_window().size.x - 50)
	_choose_new_target()

func _update_floor_position():
	var current_window_h = get_window().size.y
	
	farmer_height = col_shape.shape.size.y
	
	var actual_col_height = farmer_height * col_shape.scale.y * self.scale.y
	
	floor_y = current_window_h - (actual_col_height / 2)
	
	floor_y -= 2
	
	global_position.y = floor_y
	
	print("Chiều cao vùng va chạm: ", actual_col_height)
	print("Sàn tính theo Collision: ", floor_y)

func _physics_process(delta):
	if abs(position.x - target_x) > 5:
		var direction = sign(target_x - position.x)
		velocity.x = direction * speed
		
		anim.play("walk")
		anim.flip_h = (direction < 0)
	else:
		velocity.x = 0
		anim.play("idle")
		
		if randf() < 0.005:
			_choose_new_target()
			
	move_and_slide()
	# Ép Y luôn bằng sàn của cửa sổ game
	position.y = floor_y

func _choose_new_target():
	target_x = randf_range(100, get_window().size.x - 100)
