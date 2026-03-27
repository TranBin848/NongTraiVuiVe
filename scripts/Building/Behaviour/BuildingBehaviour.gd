extends Node2D
class_name BuildingBehaviour

signal sig_got_destroyed()

@export var building_state_machine: BaseStateMachine
@export var construct_component: ConstructComponent
@export var sprite: Sprite2D
@export var click_area: Area2D
@export var collision_shape: CollisionShape2D 
@export var progress_bar: ProgressBar

var building_data: BuildingData
var building_config: BuildingConfig


func _ready() -> void:
	pass


func building_init(_building_data: BuildingData) -> void:
	building_data = _building_data
	building_config = ConfigManager.get_building_config(building_data.building_id)

	# Setup construct component with data
	if construct_component:
		construct_component.set_construct_data(building_data.construct_data)

	# Position building based on saved position_x
	global_position.x = building_data.position_x
	_update_floor_position()


func _update_floor_position() -> void:
	# Calculate floor position using collision shape (like farmer.gd)
	var current_window_h = get_window().size.y

	# Get collision shape height
	var building_height: float = 0.0
	if collision_shape and collision_shape.shape is RectangleShape2D:
		var shape: RectangleShape2D = collision_shape.shape
		building_height = shape.size.y * collision_shape.scale.y * scale.y

	# Position building so its bottom sits on the floor
	var floor_y = current_window_h - (building_height / 2)

	# Small offset to sit nicely on floor
	floor_y -= 2

	# Apply floor offset from config if available
	if building_config:
		floor_y -= building_config.floor_offset_y

	global_position.y = floor_y


func start_building_state_machine() -> void:
	if building_state_machine:
		building_state_machine.start_machine()


func get_saved_building_data() -> BuildingData:
	# Update position before saving
	building_data.position_x = global_position.x
	return building_data


func destroy() -> void:
	sig_got_destroyed.emit()
	GlobalSignal.building_destroyed.emit(self)
	queue_free()
