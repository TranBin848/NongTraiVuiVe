extends Panel

@onready var icon: TextureRect = $Icon
@onready var amount_label: Label = $Amount

var slot_index: int = -1

func _ready() -> void:
	# Lắng nghe thay đổi từ Manager
	InventoryManager.inventory_updated.connect(update_visual)
	gui_input.connect(_on_gui_input)

func update_visual() -> void:
	if slot_index < 0 or slot_index >= InventoryManager.inventory_data.slots.size():
		return
		
	var data = InventoryManager.inventory_data.slots[slot_index]
	if data:
		icon.texture = data.get_texture()
		amount_label.text = str(data.amount)
		amount_label.visible = data.amount > 1
		icon.visible = true
	else:
		icon.visible = false
		amount_label.visible = false

# Hàm xử lý Click Kéo Thả
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var current_item = InventoryManager.inventory_data.slots[slot_index]
		var dragged_item = InventoryManager.dragged_item
		
		# Logic móc/đặt/hoán đổi đồ
		if dragged_item == null and current_item == null:
			pass # Cả 2 đều rỗng
		elif dragged_item == null and current_item != null:
			# Bốc lên chuột
			InventoryManager.dragged_item = current_item
			InventoryManager.inventory_data.slots[slot_index] = null
			Input.set_custom_mouse_cursor(current_item.get_cursor_texture(), Input.CURSOR_ARROW, Vector2(16, 16))
			InventoryManager.inventory_updated.emit()
			
		elif dragged_item != null and current_item == null:
			# Bỏ xuống ô trống
			InventoryManager.inventory_data.slots[slot_index] = dragged_item
			InventoryManager.dragged_item = null
			Input.set_custom_mouse_cursor(null)
			InventoryManager.inventory_updated.emit()
			
		elif dragged_item != null and current_item != null:
			# Cả chuột và ô đều có đồ -> Stack hoặc Swap
			if dragged_item.item_id == current_item.item_id:
				var space = current_item.max_stack - current_item.amount
				if space >= dragged_item.amount:
					current_item.amount += dragged_item.amount
					InventoryManager.dragged_item = null
					Input.set_custom_mouse_cursor(null)
				else:
					current_item.amount += space
					dragged_item.amount -= space
			else:
				# Đổi chỗ
				InventoryManager.inventory_data.slots[slot_index] = dragged_item
				InventoryManager.dragged_item = current_item
				Input.set_custom_mouse_cursor(current_item.get_cursor_texture(), Input.CURSOR_ARROW, Vector2(16, 16))
			
			InventoryManager.inventory_updated.emit()
