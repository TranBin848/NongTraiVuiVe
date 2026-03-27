extends Node

signal inventory_updated()

var inventory_data: InventoryData = InventoryData.new(20) # Mặc định túi 20 ô
var dragged_item: ItemData = null # Item đang được cầm trên chuột

func add_item(item_id: String, amount: int = 1) -> void:
	# 1. Ưu tiên tìm ô đang có cùng loại vật phẩm và nhét thêm vào
	for i in range(inventory_data.slots.size()):
		var slot = inventory_data.slots[i]
		if slot != null and slot.item_id == item_id:
			var space = slot.max_stack - slot.amount
			if space > 0:
				if amount <= space:
					slot.amount += amount
					inventory_updated.emit()
					return
				else:
					slot.amount += space
					amount -= space
					
	# 2. Nếu rớt ra ngoài hoặc chưa có, tìm ô trống đầu tiên
	if amount > 0:
		for i in range(inventory_data.slots.size()):
			var slot = inventory_data.slots[i]
			if slot == null:
				var new_slot = ItemData.new(item_id, 0)
				if amount > new_slot.max_stack:
					new_slot.amount = new_slot.max_stack
					inventory_data.slots[i] = new_slot
					amount -= new_slot.max_stack
				else:
					new_slot.amount = amount
					inventory_data.slots[i] = new_slot
					amount = 0
					break
					
	inventory_updated.emit()
