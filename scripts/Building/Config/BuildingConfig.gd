extends Resource
class_name BuildingConfig

@export var building_id: EnumType.Building
@export var prefab: PackedScene
@export var name: String
@export var texture: Texture2D
@export var construct_config: ConstructConfig

@export var building_size: int = 1 # Kích thước lấn ô trên Lưới Grid

## Vertical offset from floor for building placement
@export var floor_offset_y: float = 0.0

func get_id() -> int:
	return building_id
