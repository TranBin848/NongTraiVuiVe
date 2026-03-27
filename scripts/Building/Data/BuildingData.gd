extends Resource
class_name BuildingData

@export var building_id: EnumType.Building
@export var construct_data: ConstructData
@export var position_x: float


func _init(
	_building_id: EnumType.Building = EnumType.Building.NONE,
	_position_x: float = 0.0,
	_construct_data: ConstructData = null
) -> void:
	building_id = _building_id
	position_x = _position_x
	if _construct_data:
		construct_data = _construct_data
	else:
		construct_data = ConstructData.new()


func get_id() -> int:
	return building_id
