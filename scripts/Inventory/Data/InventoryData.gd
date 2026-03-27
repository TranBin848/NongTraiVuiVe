extends Resource
class_name InventoryData

@export var slots: Array[ItemData] = []

func _init(size: int = 20) -> void:
	slots.resize(size)
	for i in range(size):
		slots[i] = null
