extends Node

var active_buildings: Array[BuildingBehaviour] = []


func _ready() -> void:
	# Connect to global signals
	GlobalSignal.building_destroyed.connect(_on_building_destroyed)


## Spawn a building at position
func spawn_building(building_id: EnumType.Building, position_x: float) -> BuildingBehaviour:
	var config := ConfigManager.get_building_config(building_id)
	if not config:
		push_error("BuildingConfig not found for id: " + str(building_id))
		return null

	if not config.prefab:
		push_error("BuildingConfig has no prefab for: " + config.name)
		return null

	# Create building data
	var building_data := BuildingData.new(building_id, position_x)

	# Instantiate prefab
	var building: BuildingBehaviour = config.prefab.instantiate()
	if not building:
		push_error("Failed to instantiate building prefab")
		return null

	# Add to scene tree
	get_tree().current_scene.add_child(building)

	# Initialize building
	building.building_init(building_data)
	building.start_building_state_machine()

	# Track building
	active_buildings.append(building)

	GlobalSignal.building_placed.emit(building)
	return building


## Spawn a building with existing data (for loading saved games)
func spawn_building_from_data(building_data: BuildingData) -> BuildingBehaviour:
	var config := ConfigManager.get_building_config(building_data.building_id)
	if not config or not config.prefab:
		return null

	var building: BuildingBehaviour = config.prefab.instantiate()
	if not building:
		return null

	get_tree().current_scene.add_child(building)
	building.building_init(building_data)
	building.start_building_state_machine()
	active_buildings.append(building)

	return building


## Get all active buildings
func get_all_buildings() -> Array[BuildingBehaviour]:
	return active_buildings


## Get saved data for all buildings
func get_all_building_data() -> Array[BuildingData]:
	var data_list: Array[BuildingData] = []
	for building in active_buildings:
		data_list.append(building.get_saved_building_data())
	return data_list


func _on_building_destroyed(building: BuildingBehaviour) -> void:
	active_buildings.erase(building)
